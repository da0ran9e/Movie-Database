import React, { Fragment, useEffect, useCallback } from "react";
import { Link } from "react-router-dom";

const MovieList = ({movies, setMovies, isMan, isReset }) => {

	const getMovies = useCallback(async () => {
		const res = await fetch("http://localhost:5000/movies");
		var movieArray = await res.json();

		if (movieArray.length > 50) {
			movieArray = movieArray.slice(0,50);
		}

		console.log(typeof movieArray);
		// Set the state
		setMovies(movieArray);
	}, [setMovies]);

	useEffect(() => {
		getMovies();
	}, [getMovies]);

	return (
		<Fragment>
			<div className="movie-wrapper">
				{
					movies.map(movie => (
						<div key={movie.movie_id}>
							<div  className="movie-poster-wrapper">
								<img className="movie-poster-item" 
									src={movie.poster_url.replace(".jpg", "_UX512_.jpg")}
									alt={movie.movie_id}
									onError={({currentTarget}) => {
										currentTarget.src="/poster-error.png";
										currentTarget.onerror=null;
									}}
								></img>
								{!isMan ? 
									<Link to={"/booking/" + movie.movie_id} className="btn btn-success btn-lg" >Buy ticket</Link>
								: 
									<Link to={"/addscreening/" + movie.movie_id} className="btn btn-success btn-lg" >Add Screening</Link>
								}
							</div>
							<h4>{movie.title}</h4>
						</div>
					))
				}
			</div>
		</Fragment>
	)
}

export default MovieList;