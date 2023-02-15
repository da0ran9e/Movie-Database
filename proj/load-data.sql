\copy Movie FROM 'Movie.csv' (format csv, header match, delimiter ',', encoding 'utf8');
\copy Genre FROM 'Genre.csv' (format csv, header match, delimiter ',', encoding 'utf8');
\copy join_movie_genre FROM 'join_movie_genre.csv' (format csv, header match, delimiter ',', encoding 'utf8');

\copy Director FROM 'Director.csv' (format csv, header match, delimiter ',', encoding 'utf8');
\copy join_movie_director FROM 'join_movie_director.csv' (format csv, header match, delimiter ',', encoding 'utf8');

\copy Casts FROM 'Cast.csv' (format csv, header match, delimiter ',', encoding 'utf8');
\copy join_movie_cast FROM 'join_movie_cast.csv' (format csv, header match, delimiter ',', encoding 'utf8');

\copy Customer FROM 'Customer.csv' (format csv, header match, delimiter ',', encoding 'utf8');

\copy Room FROM 'Room.csv' (format csv, header match, delimiter ',', encoding 'utf8');