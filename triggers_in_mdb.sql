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
	IF (a > 149) AND (TG_TABLE_NAME = 'SEAT') THEN -- If cascaded from room then bypass
		RAISE NOTICE 'CANNOT INSERT/DELETE SEAT';
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


--7. Chặn việc xóa screening khi đã có người đặt vé
-- CREATE OR REPLACE FUNCTION prevent_delete_screening()
-- RETURNS TRIGGER LANGUAGE plpgsql
-- AS $$
-- BEGIN
-- 	if(NEW.available_seat < 150) then
-- 		raise notice 'This screening was be booked so it can not be deleted';
-- 		return null;
-- 	end if;
-- 	return new;
-- END
-- $$;

-- CREATE OR REPLACE TRIGGER prevent_delete_screening
-- BEFORE DELETE ON screening
-- FOR EACH ROW
-- EXECUTE PROCEDURE prevent_delete_screening();

--8. Chưa viết được trigger chặn xóa phòng đã được book



-- 9. Error with input
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