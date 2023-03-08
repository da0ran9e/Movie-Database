-- FUNCTION BOOK TICKET

-- 1. GET SCREENING information and price
CREATE OR REPLACE FUNCTION client_get_screening(movie_id integer, day date)
RETURNS SETOF Screening AS
$$
BEGIN
	RETURN QUERY
	SELECT *
	FROM Screening SR
	WHERE SR.movie_id=$1 AND SR.screen_date=$2;
END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION client_get_price(screen_id integer)
RETURNS INT AS
$$
DECLARE
	price INT;
	day_of_week INT;
	screen_time INT;
	room_type VARCHAR(10);
BEGIN
	SELECT EXTRACT(DOW FROM SR.screen_date) + 1, EXTRACT(HOUR FROM SR.start_time), R.room_type
	INTO STRICT day_of_week, screen_time, room_type
	FROM Screening SR JOIN Room R ON SR.room_id=R.room_id
	WHERE SR.screen_id=$1;

	-- 1=Sunday, 2-7=Mon-Sat
	IF day_of_week BETWEEN 2 AND 5 THEN
		IF screen_time BETWEEN 8 AND 12 THEN
			price := 50000;
		ELSIF screen_time BETWEEN 12 AND 22 THEN
			price := 75000;
		ELSE
			price := 60000;
		END IF;
	ELSE
		IF screen_time BETWEEN 8 AND 12 THEN
			price := 65000;
		ELSIF screen_time BETWEEN 12 AND 22 THEN
			price := 85000;
		ELSE
			price := 70000;
		END IF;
	END IF;

	IF room_type = '3D' THEN
		price := price + 20000;
	END IF;

	RETURN price;

	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			RAISE EXCEPTION 'Screening % not found', screen_id;
		WHEN TOO_MANY_ROWS THEN
			RAISE EXCEPTION 'Screening % not unique', screen_id;
END;
$$
LANGUAGE plpgsql;



-- 2. FIND EMPTY SEATS
CREATE OR REPLACE FUNCTION get_seat_all(screen_id integer)
RETURNS TABLE(
	seat_id integer,
	seat_row varchar(5),
	seat_num integer
) AS
$$
BEGIN
	RETURN QUERY
	SELECT S.seat_id, S.row, S.num
	FROM Seat S JOIN Screening SR ON S.room_id=SR.room_id
	WHERE SR.screen_id=$1;
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_seat_booked(screen_id integer)
RETURNS TABLE(
	seat_id integer,
	seat_row varchar(5),
	seat_num integer
) AS
$$
BEGIN
	RETURN QUERY
	SELECT S.seat_id, S.row, S.num
	FROM Seat S JOIN Ticket T ON S.seat_id=T.seat_id
	WHERE T.screen_id=$1;
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION client_get_seat_empty(screen_id integer)
RETURNS TABLE(
	seat_id integer,
	seat_row varchar(5),
	seat_num integer
) AS
$$
BEGIN
	RETURN QUERY
	SELECT A.seat_id, A.seat_row, A.seat_num
	FROM get_seat_all($1) A 
	LEFT JOIN get_seat_booked($1) B ON A.seat_id=B.seat_id
	WHERE B.seat_id IS NULL;
END;
$$
LANGUAGE plpgsql;



-- 3. BOOKING TICKETS

CREATE OR REPLACE FUNCTION check_valid_user(userid int)
RETURNS BOOLEAN
LANGUAGE plpgsql
AS $$
DECLARE
	a int;
BEGIN
	select count(*) from customer into a where customer.user_id = userid;
	if a = 1 then
		return true;
	else 
		return false;
	end if;
END
$$;

CREATE OR REPLACE FUNCTION check_available_seat_in_screen(screenid int, seatid int)
RETURNS BOOLEAN
LANGUAGE plpgsql
AS $$
DECLARE 
	a int;
	b int;
	c int;
BEGIN
	select count(*) from screening into a where screen_id = screenid and available_seat != 0;
	select count(*) from seat into c where seat_id = seatid;
	if(a != 0 and c = 1) then
	
		select count(*) from ticket into b where screen_id = screenid and seat_id = seatid;
		if( b = 0) then
			return true;
		else
			raise notice 'Seat taken.';  
			return false;
		end if;
	
	else
		raise notice 'Screening/Seat does not exist OR there is no available seat.'; 
		return false;
	end if;
END
$$;

--a. (LOGGED IN) with user_id

CREATE OR REPLACE FUNCTION book_ticket(userid int, screenid int, seatid int)
RETURNS SETOF Ticket
LANGUAGE plpgsql
AS $$
BEGIN
	IF check_valid_user(userid) THEN
		if check_available_seat_in_screen(screenid, seatid) then
			RETURN QUERY
			INSERT INTO Ticket (screen_id, total_price, seat_id, user_id)
			VALUES (screenid, client_get_price(screenid), seatid, userid) RETURNING *;
			raise notice 'Successfully booked! Congratulations!';
		else
			raise notice '(User) The screening does not exist or the seatid was booked by someone else';
			return;
		end if;
	ELSE
		raise notice 'This user does not exist';
		return;
	END IF;
END
$$;


--b. (NOT LOGGED IN) Email

CREATE OR REPLACE FUNCTION book_ticket_email(u_email text, screenid int, seatid int)
RETURNS SETOF Ticket
LANGUAGE plpgsql
AS $$
BEGIN
	IF check_available_seat_in_screen(screenid, seatid) THEN
		RETURN QUERY
		INSERT INTO Ticket (screen_id, total_price, seat_id, email)
		VALUES (screenid, client_get_price(screenid), seatid, u_email) RETURNING *;
		raise notice 'Successfully booked! Congratulations!';
	ELSE
		raise notice '(Email) The screening does not exist or the seatid was booked by someone else';
		return;
	END IF;
END
$$;
