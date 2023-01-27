alter table movie_genres(
    add constraint foreign key movie_id references movie(movie_id)
);

alter table movie_casts(
    add constraint foreign key movie_id references movie(movie_id)
);

alter table movie_directors(
    add constraint foreign key movie_id references movie(movie_id)
);

alter table screening(
    add constraint foreign key movie_id references movie(movie_id),
    add constraint foreign key room_id references room(room_id)
);

alter table room(
    add constraint foreign key cinema_id references cinema(cinema_id)
);

alter table manager(
    add constraint foreign key cinema_id references cinema(cinema_id)
);

alter table seat(
    add constraint foreign key room_id references room(room_id)
);

alter table ticket(
    add constraint foreign key seat_id references seat(seat_id),
    add constraint foreign key user_id references customer(user_id),
    add constraint foreign key screen_id references screening(screen_id)
);