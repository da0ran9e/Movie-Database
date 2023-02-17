-- 1. Auto add seat when insert room
CREATE OR REPLACE FUNCTION add_seat() RETURNS TRIGGER 
LANGUAGE plpgsql 
AS 
$$
DECLARE 
	ch record;
BEGIN
		for ch in (select a FROM regexp_split_to_table('ABCDEFGHIJ', '') AS a) loop
			for n in 1..15 loop
				INSERT INTO seat VALUES (DEFAULT, ch, n, NEW.room_id);
			end loop;
		end loop;
		return new;
END
$$;

CREATE OR REPLACE TRIGGER seat_addition
AFTER INSERT ON room
FOR EACH ROW
EXECUTE PROCEDURE add_seat();






-- 2. Set available seat to 150 when create a screening

CREATE OR REPLACE FUNCTION available_seat_default_150()
RETURNS TRIGGER LANGUAGE plpgsql
AS $$
BEGIN
	UPDATE screening SET available_seat = 150
	WHERE screen_id = NEW.screen_id;
	RETURN NEW;
END
$$;

CREATE OR REPLACE TRIGGER set_available_seat
AFTER INSERT ON screening
FOR EACH ROW
EXECUTE PROCEDURE available_seat_default_150();





-- Trigger: Đặt thêm seat thì giảm available seat ở Screening, 
-- giảm seat thì tăng available seat ở Screening

--3. Book ticket
CREATE OR REPLACE FUNCTION book_ticket() RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
	UPDATE screening SET available_seat = available_seat - 1
	WHERE screen_id = NEW.screen_id;
	RETURN NEW;
END
$$;

CREATE OR REPLACE TRIGGER book_ticket_trigger 
AFTER INSERT ON ticket
FOR EACH ROW
EXECUTE PROCEDURE book_ticket();


--4. Cancel ticket
CREATE OR REPLACE FUNCTION cancel_ticket() RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
	UPDATE screening SET available_seat = available_seat + 1
	WHERE screen_id = OLD.screen_id;
	RETURN NEW;
END
$$;

CREATE OR REPLACE TRIGGER cancel_ticket_trigger 
AFTER DELETE ON ticket
FOR EACH ROW
EXECUTE PROCEDURE cancel_ticket();




-- 