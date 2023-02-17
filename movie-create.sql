CREATE TABLE Movie (
	movie_id serial PRIMARY KEY,
	title varchar(200) NOT NULL,
	description text NOT NULL UNIQUE,
	age_restriction varchar(5),	-- P, C13, C16, C18, N/A
	duration interval NOT NULL,
	release_date date
);

CREATE TABLE Genre (
	genre_id serial PRIMARY KEY,
	genre_name varchar(30)
);

CREATE TABLE join_movie_genre (
	movie_id integer,
	genre_id integer
	
);

CREATE TABLE Director (
	director_id serial PRIMARY KEY,
	director_name varchar(50)
);

CREATE TABLE join_movie_director (
	movie_id integer,
	director_id integer
);

CREATE TABLE Casts (
	cast_id serial PRIMARY KEY,
	cast_name varchar(50)
);

CREATE TABLE join_movie_cast (
	movie_id integer,
	cast_id integer
	
	-- cast_character varchar(100)
);


--- End of movie related

/*
CREATE TABLE Manager (
	manager_id serial PRIMARY KEY,
	name varchar(50) NOT NULL,
	phone_number char(10) NOT NULL,
	cinema_id integer NOT NULL
);

CREATE TABLE Cinema (
	cinema_id serial PRIMARY KEY,
	address varchar(255) NOT NULL,
	name varchar(30) NOT NULL
);
*/

CREATE TABLE Room (
	room_id serial PRIMARY KEY,
	room_type varchar(10) NOT NULL
	-- cinema_id integer NOT NULL
);

CREATE TABLE Screening (
	screen_id serial PRIMARY KEY,
	screen_date date NOT NULL,
	start_time time NOT NULL,
	available_seat integer NOT NULL DEFAULT 150,
	screen_type varchar(10) NOT NULL,
	room_id integer NOT NULL,
	movie_id integer NOT NULL
);

CREATE TABLE Seat (
	seat_id serial PRIMARY KEY,
	row varchar(5) NOT NULL,
	num integer NOT NULL,
	room_id integer NOT NULL
);

CREATE TABLE Ticket (
	ticket_id serial PRIMARY KEY,
	email varchar(100),
	total_price integer NOT NULL,
	screen_id integer NOT NULL,
	seat_id integer NOT NULL,
	user_id integer, -- NOT NULL -- Can be null with people having no membership

	CONSTRAINT ck_ticket_contact CHECK ((email IS NOT NULL) OR (user_id IS NOT NULL))
);

CREATE TABLE Customer (
	user_id serial PRIMARY KEY,
	name varchar(50) NOT NULL,
	phone_number varchar(15),
	email varchar(100),
	password varchar(100) NOT NULL,
	
	CONSTRAINT ck_cust_mail_or_phone CHECK ((email IS NOT NULL) OR (phone_number IS NOT NULL))
);

