--- SCREENING-RELATED FUNCTIONS ---
CREATE OR REPLACE FUNCTION CreateNewScreening(sn_movie_id int, sn_date date, sn_start_time time without time zone, sn_room_id int)
RETURNS BOOLEAN AS
$$
    IF EXISTS (SELECT * FROM Screening WHERE screen_date = sn_date AND start_time = sn_start_time)
        BEGIN
            RAISE NOTICE 'Screening session already existed in the time slot: (%) (%).', sn_date, start_time;
            RETURN FALSE
        END
    ELSE
        INSERT INTO screening(movie_id, screen_date, start_time, room_id) = (sn_movie_id, sn_date, sn_start_time, sn_room_id)
        IF @@ROWCOUNT = 1 --number of row affected upon insertion
            RAISE NOTICE 'Insertion successful.';
            RETURN TRUE
        ELSE 
            RAISE NOTICE 'Insertion failed.';
            RETURN FALSE

$$

--- FILM-RELATED FUNCTIONS ---
CREATE OR REPLACE FUNCTION DeleteMovie(del_movie_id int)
RETURNS BOOLEAN AS
$$
    DELETE FROM movie
    WHERE movie_id = del_movie_id
    RETURN 
$$

CREATE OR REPLACE FUNCTION AddMovie(new_movie_title text[], new_description text[], new_age_restriction int, new_duration interval, new_release_date date)
RETURNS BOOLEAN AS
$$
    IF EXISTS(SELECT * FROM movie WHERE movie_title = new_movie_title)
        RAISE NOTICE 'The movie already existed.';
        RETURN FALSE
    ELSE  
        INSERT INTO movie(movie_title, description, age_restriction, duration, release_date) = (new_movie_title, new_description, new_age_restriction, new_duration, new_release_date)
        IF @@ROWCOUNT = 1 --number of row affected upon insertion
            RAISE NOTICE 'Insertion successful.';
            RETURN TRUE
        ELSE 
            RAISE NOTICE 'Insertion failed.';
            RETURN FALSE
$$

CREATE OR REPLACE FUNCTION EditMovie(edit_movie_id int, edit_title text[])
RETURNS TABLE AS
$$
    IF EXISTS(SELECT * FROM movie WHERE movie_id = edit_movie_id)
        UPDATE TABLE movie
        SET title = edit_title
        WHERE movie_id = edit_movie_id;
    ELSE 
        RAISE NOTICE 'No movie with ID (%) exists.', edit_movie_id;
$$



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
	select extract(dow from screen_date) + 1  
		from screening as s
		into day_of_week 
		where s.screen_id = NEW.screen_id;
	
	SELECT EXTRACT(HOUR FROM SR.start_time), R.room_type
		INTO STRICT screen_time, roomtype
		FROM Screening SR JOIN Room R ON SR.room_id=R.room_id
		WHERE SR.screen_id = screen_id;
	
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

	IF roomtype = '3D' THEN
		price := price + 20000;
	END IF;
	
	UPDATE ticket set total_price = price where ticket_id = new.ticket_id;
	
	return new;
END
$$;

CREATE OR REPLACE TRIGGER auto_price
AFTER INSERT ON ticket
FOR EACH ROW
EXECUTE PROCEDURE auto_price();