--- FILM-RELATED FUNCTIONS ---
CREATE OR REPLACE FUNCTION SearchMovieByTitle(str_title text[])
RETURNS TABLE AS
$$
BEGIN
	SELECT *
	FROM movie
	WHERE LOCATE (title, str_title) <> 0
END;
$$

CREATE OR REPLACE FUNCTION SearchMovieByGenre(str_genre text[])
RETURNS TABLE AS
$$
BEGIN
	SELECT *
	FROM movie 
	WHERE LOCATE (genre, str_genre) <> 0
END;
$$

CREATE OR REPLACE FUNCTION SearchMovieByAge(age int)
RETURNS TABLE AS
$$
BEGIN
	SELECT *
	FROM movie
	WHERE m.age_restriction::int <= age
END;
$$

CREATE OR REPLACE FUNCTION SearchMovieByDuration(duration interval)
RETURNS TABLE AS
$$
BEGIN
	SELECT *
	FROM movie 
	WHERE m.duration = duration
END;
$$

--- SEAT-RELATED FUNCTIONS ---
CREATE OR REPLACE FUNCTION CheckEmptySeat(movie_title text[], d_day date)
RETURNS TABLE AS
$$
BEGIN
	SELECT row, num, room_id
	FROM seat s
        INNER JOIN ticket t ON s.seat_id = t.seat_id
        INNER JOIN screening sn ON t.screen_id = sn.screen_id
        INNER JOIN movie m ON sn.movie_id = m.movie_id
	WHERE m.title = movie_title AND sn.screen_date = d_day
    HAVING t.ticket_id = NULL
    GROUP BY room_id
END;
$$

--- TICKET-RELATED FUNCTIONS --- 
CREATE OR REPLACE FUNCTION GetOrderedTicket(user_email text[])
-- Do we keep track of past tickets for users as well, or just keep only the ticket available in future screening?
RETURNS TABLE AS
$$
BEGIN
	SELECT *
	FROM ticket 
	WHERE email = user_email
END;
$$

CREATE OR REPLACE FUNCTION CancelTicket()
RETURNS BOOLEAN AS
$$
BEGIN
	
END;
$$

CREATE OR REPLACE FUNCTION BookTicket()
RETURNS TABLE AS
$$
BEGIN
	
END;
$$

-- How to filter bad input and still return some results?