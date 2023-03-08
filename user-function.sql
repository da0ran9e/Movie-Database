-- FUNCTION BOOK TICKET

-- 1. Check valid user
-- a. user_id
CREATE OR REPLACE FUNCTION check_valid_user(userid int)
RETURNS BOOLEAN
LANGUAGE plpgsql
AS $$
DECLARE
	a int;
BEGIN
	select count(*) from customer into a where customer.user_id = userid;
	if a = 0 then return false;
	else return true;
	end if;
END
$$;

--2. Check available_seat_in_screen

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


--3. BOOK TICKET:

--a. user_id

CREATE OR REPLACE FUNCTION book_ticket(userid int, screenid int, seatid int)
RETURNS SETOF Ticket
LANGUAGE plpgsql
AS $$
DECLARE
	a text;
BEGIN
	IF check_valid_user(userid) THEN
		if check_available_seat_in_screen(screenid, seatid) then
			RETURN QUERY
			INSERT INTO Ticket (screen_id, total_price, seat_id, user_id)
			VALUES (screenid, client_get_price(screenid), seatid, userid) RETURNING *;
			raise notice 'Success! Congratulations!';
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


--b. Email

CREATE OR REPLACE FUNCTION book_ticket(u_email text, screenid int, seatid int)
RETURNS SETOF Ticket
LANGUAGE plpgsql
AS $$
DECLARE
	a text;
BEGIN
	IF check_available_seat_in_screen(screenid, seatid) THEN
		RETURN QUERY
		INSERT INTO Ticket (screen_id, total_price, seat_id, email)
		VALUES (screenid, client_get_price(screenid), seatid, u_email) RETURNING *;
		raise notice 'Success! Congratulations!';
	ELSE
		raise notice '(Email) The screening does not exist or the seatid was booked by someone else';
		return;
	END IF;
END
$$;
