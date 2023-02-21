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
CREATE OR REPLACE FUNCTION GetOrderedTicketbyEmail(current_user_email text[])
-- Do we keep track of past tickets for users as well, or just keep only the ticket available in future screening?
RETURNS TABLE AS
$$
BEGIN
	SELECT *
	FROM ticket 
	WHERE email = current_user_email
	GROUP BY screen_id
END;
$$

CREATE OR REPLACE FUNCTION GetOrderedTicketbyID(current_user_id int)
RETURNS TABLE AS
$$
BEGIN
	SELECT *
	FROM ticket 
	WHERE user_id = current_user_id
	GROUP BY screen_id
END;
$$

CREATE OR REPLACE FUNCTION CancelTicket(cancel_ticket_id int)
RETURNS BOOLEAN AS
$$
BEGIN
	IF EXISTS (
		SELECT * FROM ticket t JOIN screening sn ON t.screen_id = sn.screen_id
		WHERE t.ticket_id = t.cancel_ticket_id AND sn.screen_date >= CURRENT_DATE)
        DELETE FROM ticket
		WHERE ticket.ticket_id = cancel_ticket_id
        IF @@ROWCOUNT > 0 
            RAISE NOTICE 'Deletion successful.';
            RETURN TRUE
        ELSE 
            RAISE NOTICE 'Deletion failed.';
            RETURN FALSE
    ELSE
		BEGIN
            RAISE NOTICE 'No ticket found with the ID (%)', cancel_ticket_id;
            RETURN FALSE
        END
	
END;
$$

CREATE OR REPLACE FUNCTION BookTicket(book_movie_id int, booking_date date, quantity int)
RETURNS BOOLEAN AS
$$
BEGIN
	--Check if the movie exists, the movie has valid screening, and enough seats available for booking
	DECLARE @valid_booking int
	SET @valid_booking = 
		(IF EXISTS (SELECT *)
		)
END;
$$

-- How to filter bad input and still return some results?