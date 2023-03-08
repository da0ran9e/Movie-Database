-- CREATE OR REPLACE FUNCTION SearchMovieTitle(str_title text[])
-- RETURNS TABLE AS
-- $$
-- BEGIN
-- 	SELECT *
-- 	FROM Movies
-- 	WHERE title_tokens @@ plainto_tsquery(str_title)
-- END;
-- $$


-- UPDATE Movies M
-- SET title_tokens = to_tsvector(M.title)
-- WHERE title_tokens IS NULL;

-- --- Maybe phraseto_tsquery if we want to use <-> (FOLLOWED BY) instead of &	

-- MANAGER
CREATE OR REPLACE FUNCTION find_films(term TEXT)
RETURNS SETOF Movie AS
$$
BEGIN
	RETURN QUERY
	SELECT *
	FROM Movie
	WHERE POSITION($1 IN LOWER(title)) > 0;
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_films()
RETURNS SETOF Movie AS
$$
BEGIN
	RETURN QUERY
	SELECT *
	FROM Movie
	WHERE release_date > '2015-01-01'
	ORDER BY release_date DESC;
END;
$$
LANGUAGE plpgsql;




-- LOGIN
CREATE OR REPLACE FUNCTION login_exist_user(email_or_phone TEXT)
RETURNS SETOF Customer AS
$$
BEGIN
	RETURN QUERY
	SELECT *
	FROM Customer C
	WHERE C.email=email_or_phone OR C.phone_number=email_or_phone;
END;
$$
LANGUAGE plpgsql;




-- CLIENT
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


CREATE OR REPLACE FUNCTION client_get_seat_all(screen_id integer)
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


CREATE OR REPLACE FUNCTION client_get_seat_booked(screen_id integer)
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
		IF screen_time BETWEEN 7 AND 12 THEN
			price := 50000;
		ELSIF screen_time BETWEEN 12 AND 23 THEN
			price := 75000;
		ELSE
			price := 60000;
		END IF;
	ELSE
		IF screen_time BETWEEN 7 AND 12 THEN
			price := 65000;
		ELSIF screen_time BETWEEN 12 AND 23 THEN
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


/* Integrated into book_ticket function

-- Auto calculate price
CREATE OR REPLACE FUNCTION auto_price()
RETURNS TRIGGER LANGUAGE plpgsql
AS $$
DECLARE 
	price int;
	day_of_week int;
	screen_time int;
	roomtype varchar(10);
BEGIN
	UPDATE Ticket T
	SET total_price = client_get_price(NEW.screen_id)
	WHERE T.ticket_id=NEW.ticket_id;
	
	RETURN NEW;
END
$$;

CREATE OR REPLACE TRIGGER auto_price
AFTER INSERT ON Ticket
FOR EACH ROW
EXECUTE PROCEDURE auto_price();
*/




CREATE OR REPLACE FUNCTION get_genres(movie_id integer)
RETURNS SETOF Genre AS
$$
BEGIN
	RETURN QUERY
	SELECT G.genre_id, G.genre_name 
	FROM Genre G
	JOIN join_movie_genre J ON J.genre_id=G.genre_id
	JOIN Movie M ON J.movie_id=M.movie_id
	WHERE M.movie_id=$1;
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_directors(movie_id integer)
RETURNS SETOF Director AS
$$
BEGIN
	RETURN QUERY
	SELECT D.director_id, D.director_name 
	FROM Director D
	JOIN join_movie_director J ON J.director_id=D.director_id
	JOIN Movie M ON J.movie_id=M.movie_id
	WHERE M.movie_id=$1;
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_casts(movie_id integer)
RETURNS SETOF Casts AS
$$
BEGIN
	RETURN QUERY
	SELECT C.cast_id, C.cast_name 
	FROM Casts C
	JOIN join_movie_cast J ON J.cast_id=C.cast_id
	JOIN Movie M ON J.movie_id=M.movie_id
	WHERE M.movie_id=$1;
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_seats_from_screen(screen_id integer)
RETURNS SETOF Seat AS
$$
BEGIN
	RETURN QUERY
	SELECT S.seat_id, S.row, S.num, S.room_id 
	FROM Seat S 
	JOIN Room R ON R.room_id=S.room_id
	JOIN Screening SR ON SR.room_id=R.room_id
	WHERE SR.screen_id=$1;
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_seats_taken_from_screen(screen_id integer)
RETURNS SETOF Seat AS
$$
BEGIN
	RETURN QUERY
	SELECT S.seat_id, S.row, S.num, S.room_id 
	FROM Seat S
	JOIN Room R ON R.room_id=S.room_id
	JOIN Screening SR ON SR.room_id=R.room_id
	JOIN Ticket T ON S.seat_id=T.seat_id
	WHERE SR.screen_id=$1;
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_empty_seat(screen_id integer)
RETURNS SETOF Seat AS
$$
BEGIN
	RETURN QUERY
	SELECT S.seat_id, S.row, S.num, S.room_id 
	FROM get_seats_from_screen($1)
	WHERE NOT EXISTS (SELECT * FROM get_seats_taken_from_screen($1));
END;
$$
LANGUAGE plpgsql;
