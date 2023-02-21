--- SCREENING-RELATED FUNCTIONS ---
CREATE OR REPLACE FUNCTION CreateNewScreening(sn_movie_id int, sn_date date, sn_start_time time without time zone, sn_room_id int)
RETURNS BOOLEAN AS
$$
    IF EXISTS (SELECT * FROM Screening WHERE screen_date = sn_date AND start_time = sn_start_time)
        BEGIN
            RAISE NOTICE 'Screening session already existed in the time slot: (%) (%).', sn_date, start_time;
            RETURN 0
        END
    ELSE
        INSERT INTO screening(movie_id, screen_date, start_time, room_id) = (sn_movie_id, sn_date, sn_start_time, sn_room_id)
        IF @@ROWCOUNT = 1 
            RAISE NOTICE 'Insertion successful.';
            RETURN 1
        ELSE 
            RAISE NOTICE 'Insertion failed.';
            RETURN 0

$$

--- FILM-RELATED FUNCTIONS ---
CREATE OR REPLACE FUNCTION DeleteMovie(movie_id int)
RETURNS BOOLEAN AS
$$
    
$$

CREATE OR REPLACE FUNCTION AddMovie()
RETURNS 
$$

$$