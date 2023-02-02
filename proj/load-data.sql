\copy Genre FROM 'Genre.csv' (format csv, header true, delimiter ',', encoding 'utf8');
\copy Movie FROM 'Movie.csv' (format csv, header true, delimiter ',', encoding 'utf8');
\copy join_movie_genre FROM 'join_movie_genre.csv' (format csv, header true, delimiter ',', encoding 'utf8');