
CREATE TABLE Manager (
	manager_id serial PRIMARY KEY,
	name varchar(50) NOT NULL,
	phone_number char(10) NOT NULL
);

CREATE TABLE Cinema (
	cinema_id serial PRIMARY KEY,
	address varchar(255) NOT NULL,
	name varchar(30) NOT NULL,
	manager_id integer NOT NULL,

	CONSTRAINT fk_cinema__manager_id FOREIGN KEY (manager_id) REFERENCES Manager(manager_id) ON DELETE SET NULL
);

CREATE TABLE Room (
	room_id serial PRIMARY KEY,
	available_seat integer NOT NULL,
	cinema_id integer NOT NULL,

	CONSTRAINT fk_room__cinema_id FOREIGN KEY (cinema_id) REFERENCES Cinema(cinema_id) ON DELETE SET NULL
);

CREATE TABLE Seat (
	seat_id serial PRIMARY KEY,
	row char(1) NOT NULL,
	num integer NOT NULL,
	room_id integer NOT NULL,

	CONSTRAINT fk_seat__room_id FOREIGN KEY (room_id) REFERENCES Room(room_id) ON DELETE SET NULL
);


-- SELECT pg_catalog.setval(pg_catalog.pg_get_serial_sequence('customers', 'customerid'), 20000, true);

CREATE TABLE Customer (
	user_id serial PRIMARY KEY,
	name varchar(50) NOT NULL,
	phone_number char(10),
	email varchar(40),

	CONSTRAINT ck_cust_mail_or_phone CHECK ((email IS NOT NULL) OR (phone_number IS NOT NULL))
);

CREATE TABLE Movie (
	movie_id serial PRIMARY KEY,
	title varchar(100) NOT NULL,
	description text,
	director varchar(50),
	age_restriction varchar(5),	-- P, C13, C16, C18, N/A
	duration interval NOT NULL,
	premiere_date date NOT NULL,

	-- may be moved to another join table
	casts varchar(50)
);

CREATE TABLE Genre (
	genre_id serial PRIMARY KEY,
	genre_name varchar(30)
);

CREATE TABLE join_movie_genre (
	movie_id integer,
	genre_id integer,
	CONSTRAINT pk_join PRIMARY KEY (movie_id, genre_id),
	CONSTRAINT fk_join__movie_id FOREIGN KEY (movie_id) REFERENCES Movie(movie_id) ON DELETE CASCADE,
	CONSTRAINT fk_join__genre_id FOREIGN KEY (genre_id) REFERENCES Genre(genre_id) ON DELETE CASCADE
);

CREATE TABLE Screening (
	screen_id serial PRIMARY KEY,
	screen_date date NOT NULL,
	start_time time NOT NULL,
	screen_type varchar(10) NOT NULL,
	room_id integer NOT NULL,
	movie_id integer NOT NULL,

	CONSTRAINT fk_screen__room_id FOREIGN KEY (room_id) REFERENCES Room(room_id) ON DELETE SET NULL,
	CONSTRAINT fk_screen__movie_id FOREIGN KEY (movie_id) REFERENCES Movie(movie_id) ON DELETE SET NULL
);

CREATE TABLE Ticket (
	ticket_id serial PRIMARY KEY,
	email varchar(40),
	total_price integer NOT NULL,
	screen_id integer NOT NULL,
	seat_id integer NOT NULL,
	user_id integer NOT NULL,

	CONSTRAINT fk_ticket__seat_id FOREIGN KEY (seat_id) REFERENCES Seat(seat_id) ON DELETE SET NULL,
	CONSTRAINT fk_ticket__user_id FOREIGN KEY (user_id) REFERENCES Customer(user_id) ON DELETE SET NULL,
	CONSTRAINT fk_ticket__screen_id FOREIGN KEY (screen_id) REFERENCES Screening(screen_id) ON DELETE CASCADE
);
