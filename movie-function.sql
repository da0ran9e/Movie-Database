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
	WHERE SR.movie_id=movie_id AND screen_date=day;
END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION client_get_seat_all(screen_id integer)
RETURNS TABLE(
	seat_id integer,
	seat_row text,
	seat_num integer
) AS
$$
BEGIN
	RETURN QUERY
	SELECT S.seat_id, S.row, S.num
	FROM Seat S JOIN Screening SR ON S.room_id=SR.room_id
	WHERE SR.screen_id=screen_id;
END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION client_get_seat_booked(screen_id integer)
RETURNS TABLE(
	seat_id integer,
	seat_row text,
	seat_num integer
) AS
$$
BEGIN
	RETURN QUERY
	SELECT S.seat_id, S.row, S.num
	FROM Seat S JOIN Ticket T ON S.seat_id=T.seat_id
	WHERE T.screen_id=screen_id;
END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION client_get_price(screen_id integer, day date)
RETURNS INT AS
$$
DECLARE
	price INT;
	day_of_week INT;
	screen_time INT;
	room_type VARCHAR(10);
BEGIN
	day_of_week := EXTRACT(DOW FROM day) + 1;

	SELECT EXTRACT(HOUR FROM SR.start_time), R.room_type
	INTO STRICT screen_time, room_type
	FROM Screening SR JOIN Room R ON SR.room_id=R.room_id
	WHERE SR.screen_id=screen_id;

	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			RAISE EXCEPTION 'Screening % not found', screen_id;
		WHEN TOO_MANY_ROWS THEN
			RAISE EXCEPTION 'Screening % not unique', screen_id;
		WHEN OTHERS THEN
			RAISE EXCEPTION 'Invalid room in Screening %', screen_id;

	-- 1=Sunday, 2-7=Mon-Sat
	IF day_of_week BETWEEN 2 AND 5 THEN
		IF screen_time BETWEEN 7 AND 12 THEN
			price := 50000;
		ELSIF screen_time BETWEEN 12 AND 23 THEN
			price := 75000;
		ELSE
			price := 60000;
		ENDIF;
	ELSE
		IF screen_time BETWEEN 7 AND 12 THEN
			price := 65000;
		ELSIF screen_time BETWEEN 12 AND 23 THEN
			price := 85000;
		ELSE
			price := 70000;
		ENDIF;
	END IF;

	IF room_type = '3D' THEN
		price := price + 20000;
	END IF;

	RETURN price;
END;
$$
LANGUAGE plpgsql;


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

