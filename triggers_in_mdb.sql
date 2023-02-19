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




--5. Trigger không cho phép add seat từ ngoài vào

CREATE OR REPLACE FUNCTION unable_to_insert_seat()
RETURNS TRIGGER
LANGUAGE plpgsql
AS 
$$
DECLARE 
	a int := (select count(*) from seat where room_id = NEW.room_id);
BEGIN
	a := (select count(*) from seat where room_id = NEW.room_id);
	if(a > 149) then
		raise notice 'There is no seat like that';
		return null;
	end if;
	return new;
END
$$;

CREATE OR REPLACE TRIGGER unable_to_insert_seat_outside
BEFORE INSERT ON seat
FOR EACH ROW
EXECUTE PROCEDURE unable_to_insert_seat();


--6. Cấm xung đột screening
CREATE OR REPLACE FUNCTION screening_problem()
RETURNS TRIGGER LANGUAGE plpgsql
AS $$
DECLARE 
	a record;
	b time;
BEGIN
	b := (select (new.start_time + duration + '00:15:00') from movie where new.movie_id = movie.movie_id);
	for a in (select start_time as s, (start_time + duration + '00:15:00') as sd
			  from screening, movie 
			  where screen_date = new.screen_date 
			  	and room_id = new.room_id 
			  	and screening.movie_id = movie.movie_id ) loop
		if(a.sd > new.start_time and a.s <= new.start_time) then 
			raise notice 'The screening conflicts with another one';
			return null;
		end if;
		
		if(a.sd <= b and new.start_time <= a.s) then
			raise notice 'The screening conflicts with another one';
			return null;
		end if;
		
		if(new.start_time <= a.s and a.s < b) then
			raise notice 'The screening conflicts with another one';
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
