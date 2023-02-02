ALTER TABLE join_movie_genre
	ADD CONSTRAINT pk_join_mg PRIMARY KEY (movie_id, genre_id),
	ADD CONSTRAINT fk_join_mg__movie_id FOREIGN KEY (movie_id) REFERENCES Movie(movie_id) ON DELETE CASCADE,
	ADD CONSTRAINT fk_join_mg__genre_id FOREIGN KEY (genre_id) REFERENCES Genre(genre_id) ON DELETE CASCADE;


ALTER TABLE join_movie_director
	ADD CONSTRAINT pk_join_md PRIMARY KEY (movie_id, director_id),
	ADD CONSTRAINT fk_join_md__movie_id FOREIGN KEY (movie_id) REFERENCES Movie(movie_id) ON DELETE CASCADE,
	ADD CONSTRAINT fk_join_md__director_id FOREIGN KEY (director_id) REFERENCES director(director_id) ON DELETE CASCADE;

ALTER TABLE join_movie_cast
	ADD CONSTRAINT pk_join_mc PRIMARY KEY (movie_id, cast_id),
	ADD CONSTRAINT fk_join_mc__movie_id FOREIGN KEY (movie_id) REFERENCES Movie(movie_id) ON DELETE CASCADE,
	ADD CONSTRAINT fk_join_mc__cast_id FOREIGN KEY (cast_id) REFERENCES casts(cast_id) ON DELETE CASCADE;

ALTER TABLE Manager
	ADD CONSTRAINT fk_manager__cinema_id FOREIGN KEY (cinema_id) REFERENCES Cinema(cinema_id) ON DELETE SET NULL;

ALTER TABLE Room
	ADD CONSTRAINT fk_room__cinema_id FOREIGN KEY (cinema_id) REFERENCES Cinema(cinema_id) ON DELETE SET NULL;

ALTER TABLE Seat
	ADD CONSTRAINT fk_seat__room_id FOREIGN KEY (room_id) REFERENCES Room(room_id) ON DELETE SET NULL;

ALTER TABLE Screening
	ADD CONSTRAINT fk_screen__room_id FOREIGN KEY (room_id) REFERENCES Room(room_id) ON DELETE SET NULL,
	ADD CONSTRAINT fk_screen__movie_id FOREIGN KEY (movie_id) REFERENCES Movie(movie_id) ON DELETE SET NULL;

ALTER TABLE Ticket
	ADD CONSTRAINT fk_ticket__seat_id FOREIGN KEY (seat_id) REFERENCES Seat(seat_id) ON DELETE SET NULL,
	ADD CONSTRAINT fk_ticket__user_id FOREIGN KEY (user_id) REFERENCES Customer(user_id) ON DELETE SET NULL,
	ADD CONSTRAINT fk_ticket__screen_id FOREIGN KEY (screen_id) REFERENCES Screening(screen_id) ON DELETE CASCADE;


--- WITH CHECK (