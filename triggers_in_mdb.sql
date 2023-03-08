-- 1. Auto add seat when insert room
CREATE OR REPLACE FUNCTION add_seat()
RETURNS TRIGGER AS 
$$
DECLARE 
	ch CHAR(1);
BEGIN
		FOREACH ch IN ARRAY regexp_split_to_array('ABCDEFGHIJ', '') LOOP
			FOR n in 1..15 LOOP
				INSERT INTO Seat VALUES (DEFAULT, ch, n, NEW.room_id);
			END LOOP;
		END LOOP;
		RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER tr_add_seat
AFTER INSERT ON Room
FOR EACH ROW
EXECUTE PROCEDURE add_seat();



-- Trigger: Đặt thêm seat thì giảm available seat ở Screening, 
-- giảm seat thì tăng available seat ở Screening

--2. Book ticket
CREATE OR REPLACE FUNCTION book_ticket() RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
	UPDATE Screening SET available_seat = available_seat - 1
	WHERE screen_id = NEW.screen_id;
	RETURN NEW;
END
$$;

CREATE OR REPLACE TRIGGER tr_book_ticket
AFTER INSERT ON Ticket
FOR EACH ROW
EXECUTE PROCEDURE book_ticket();


--3. Cancel ticket
CREATE OR REPLACE FUNCTION cancel_ticket() RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
	UPDATE screening SET available_seat = available_seat + 1
	WHERE screen_id = OLD.screen_id;
	RETURN NEW;
END
$$;

CREATE OR REPLACE TRIGGER tr_cancel_ticket
AFTER DELETE ON Ticket
FOR EACH ROW
EXECUTE PROCEDURE cancel_ticket();



--5. Trigger không cho phép add seat từ ngoài vào
CREATE OR REPLACE FUNCTION unable_to_insert_seat()
RETURNS TRIGGER
LANGUAGE plpgsql
AS 
$$
DECLARE 
	a int := (select count(*) from Seat where room_id = NEW.room_id);
BEGIN
	IF (a > 149) AND (TG_TABLE_NAME ILIKE 'SEAT') THEN -- If cascaded from Deleting Room then bypass
		RAISE NOTICE 'CANNOT INSERT/DELETE SEAT (%)', a;
		RETURN NULL;
	END IF;
	RETURN NEW;
END
$$;

CREATE OR REPLACE TRIGGER tr_unable_to_insert_seat
BEFORE INSERT OR DELETE ON Seat
FOR EACH ROW
EXECUTE PROCEDURE unable_to_insert_seat();



--6. Cấm xung đột screening
CREATE OR REPLACE FUNCTION screening_problem()
RETURNS TRIGGER LANGUAGE plpgsql
AS $$
DECLARE 
	a record;
	new_end_time time;
BEGIN
	if (new.start_time < '08:00:00' or new.start_time > '23:30:00') then
		raise notice 'The screening is out of working hours';
		return null;
	end if;

	new_end_time := (select (new.start_time + duration + '00:15:00') from movie where new.movie_id = movie.movie_id);

	for a in (select start_time, (start_time + duration + '00:15:00') as end_time, screen_id
				from screening, movie 
				where screening.movie_id = movie.movie_id
					and screen_date = new.screen_date 
					and room_id = new.room_id) loop

		if(a.end_time > new.start_time and a.start_time < new_end_time) then 
			raise notice 'The screening conflicts with another one: %', a.screen_id;
			return null;
		end if;
	end loop;
	return new;
END
$$;
CREATE OR REPLACE TRIGGER solve_screening_problem
BEFORE INSERT ON screening
FOR EACH ROW
EXECUTE PROCEDURE screening_problem();



-- 9. Reset index for Customer (input from file doesn't increment user_id)
CREATE OR REPLACE FUNCTION reset_customer_id()
RETURNS TRIGGER 
AS $$
BEGIN
	PERFORM setval(pg_get_serial_sequence('Customer', 'user_id'), coalesce(max(user_id),0) + 1, false) FROM Customer;
	RETURN NULL;
END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE TRIGGER reset_serial_customer_id
BEFORE INSERT ON Customer
EXECUTE FUNCTION reset_customer_id();