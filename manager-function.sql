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



