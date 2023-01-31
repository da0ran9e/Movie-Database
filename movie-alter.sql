ALTER TABLE join_movie_genre
	ADD CONSTRAINT pk_join PRIMARY KEY (movie_id, genre_id),
	ADD CONSTRAINT fk_join__movie_id FOREIGN KEY (movie_id) REFERENCES Movie(movie_id) ON DELETE CASCADE,
	ADD CONSTRAINT fk_join__genre_id FOREIGN KEY (genre_id) REFERENCES Genre(genre_id) ON DELETE CASCADE;

ALTER TABLE Manager
	ADD CONSTRAINT fk_manager__cinema_id FOREIGN KEY (cinema_id) REFERENCES Cinema(cinema_id) ON DELETE SET NULL;

ALTER TABLE Room
	ADD CONSTRAINT fk_room__cinema_id FOREIGN KEY (cinema_id) REFERENCES Cinema(cinema_id) ON DELETE SET NULL;

ALTER TABLE Screening
	ADD CONSTRAINT fk_screen__room_id FOREIGN KEY (room_id) REFERENCES Room(room_id) ON DELETE SET NULL,
	ADD CONSTRAINT fk_screen__movie_id FOREIGN KEY (movie_id) REFERENCES Movie(movie_id) ON DELETE SET NULL;

ALTER TABLE Seat
	ADD CONSTRAINT fk_seat__room_id FOREIGN KEY (room_id) REFERENCES Room(room_id) ON DELETE SET NULL;

ALTER TABLE Ticket
	ADD CONSTRAINT fk_ticket__seat_id FOREIGN KEY (seat_id) REFERENCES Seat(seat_id) ON DELETE SET NULL,
	ADD CONSTRAINT fk_ticket__user_id FOREIGN KEY (user_id) REFERENCES Customer(user_id) ON DELETE SET NULL,
	ADD CONSTRAINT fk_ticket__screen_id FOREIGN KEY (screen_id) REFERENCES Screening(screen_id) ON DELETE CASCADE;


--- WITH CHECK (