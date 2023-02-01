CREATE TABLE Movie (
	movie_id serial PRIMARY KEY,
	title varchar(200) NOT NULL,
	description text,
	age_restriction varchar(5),	-- P, C13, C16, C18, N/A
	duration interval NOT NULL,
	premiere_date date NOT NULL

	-- may be moved to another join table
	-- director varchar(50),
	-- casts varchar(50)
);

CREATE TABLE Genre (
	genre_id serial PRIMARY KEY,
	genre_name varchar(30)
);

CREATE TABLE join_movie_genre (
	movie_id integer,
	genre_id integer
	
);

CREATE TABLE director (
	director_id serial PRIMARY KEY,
	director_name varchar(30)
);

CREATE TABLE join_movie_director (
	director_id integer,
	movie_id integer
	
);

CREATE TABLE casts (
	cast_id serial PRIMARY KEY,
	cast_name varchar(30)
);

CREATE TABLE join_movie_cast (
	cast_id integer,
	movie_id integer
	

);


-- TO DO: change this similar to genre
-- create table movie_casts(
-- 	movie_id int,
-- 	cast_name varchar (250),
-- 	primary key (movie_id, cast_name)
-- );

-- create table movie_directors(
-- 	movie_id int,
-- 	director_name varchar(250),
-- 	primary key (movie_id, director_name)
-- );
-- Will change this part later


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

CREATE TABLE Room (
	room_id serial PRIMARY KEY,
	available_seat integer NOT NULL,
	cinema_id integer NOT NULL
);

CREATE TABLE Screening (
	screen_id serial PRIMARY KEY,
	screen_date date NOT NULL,
	start_time time NOT NULL,
	screen_type varchar(10) NOT NULL,
	room_id integer NOT NULL,
	movie_id integer NOT NULL
);

CREATE TABLE Seat (
	seat_id serial PRIMARY KEY,
	row char(1) NOT NULL,
	num integer NOT NULL,
	room_id integer NOT NULL
);

CREATE TABLE Ticket (
	ticket_id serial PRIMARY KEY,
	email varchar(100),
	total_price integer NOT NULL,
	screen_id integer NOT NULL,
	seat_id integer NOT NULL,
	user_id integer NOT NULL
);

CREATE TABLE Customer (
	user_id serial PRIMARY KEY,
	name varchar(50) NOT NULL,
	phone_number varchar(12),
	email varchar(100),
	
	CONSTRAINT ck_cust_mail_or_phone CHECK ((email IS NOT NULL) OR (phone_number IS NOT NULL))
);

