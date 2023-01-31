create table movie(
    movie_id int primary key,
    title text,
    description text,
    age_restriction smallint,
    duration interval minute,
    premiere_date date
);

create table movie_genres(
    movie_id int,
    genre varchar(100),
    primary key (movie_id, genre)
);

create table movie_casts(
    movie_id int,
    cast_name varchar (250),
    primary key (movie_id, cast_name)
);

create table movie_directors(
    movie_id int,
    director_name varchar(250),
    primary key (movie_id, director_name)
);

create table screening(
    screen_id int primary key,
    date date,
    start_time time,
    screen_type varchar(50),
    room_id int,
    movie_id int
);

create table room(
    room_id int primary key,
    available seat int,
    cinema_id int
);

create table cinema(
    cinema_id int primary key,
    name text,
    address text
);

create table manager(
    manager_id int primary key,
    name varchar(200),
    phone_number int,
    cinema_id int
)

create table seat(
    seat_id int primary key,
    row char(1),
    number char(2),
    room_id int
);

create table ticket(
    ticket_id int,
    email varchar(200),
    total_price int,
    seat_id int,
    user_id int, 
    screen_id int
);


create table customer(
    user_id int primary key,
    name varchar(200),
    phone_number numeric,
    email varchar(250)
);

