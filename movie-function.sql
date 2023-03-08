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

CREATE OR REPLACE FUNCTION get_films()	-- Shows some of the latest first instead of loading all in (for UI)
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


-- HELPER FUNCTIONS FOR THE WEB APP:
-- LOGIN
CREATE OR REPLACE FUNCTION check_exist_user(email_or_phone TEXT)
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


-- TICKET
CREATE OR REPLACE FUNCTION get_booked_tickets(uid integer)
RETURNS SETOF Ticket AS
$$
BEGIN
	RETURN QUERY
	SELECT *
	FROM Ticket T
	WHERE T.user_id=$1;
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_booked_tickets(email text)
RETURNS SETOF Ticket AS
$$
BEGIN
	RETURN QUERY
	SELECT *
	FROM Ticket T
	WHERE T.email=$1;
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
