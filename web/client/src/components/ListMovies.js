import React, { Fragment, useEffect } from "react";


const MovieList = ({movies, setMovies, isMan }) => {

	async function getMovies() {
		const res = await fetch("http://localhost:5000/movies");
		var movieArray = await res.json();

		if (movieArray.length > 50) {
			movieArray = movieArray.slice(0,50);
		}

		// Set the state
		setMovies(movieArray);
	}

	useEffect(() => {
		getMovies();
	}, []);

	function switchManager(movie_id) {
		if (!isMan){
			return (<a href={"/booking/" + movie_id} className="btn btn-success btn-lg" >Buy ticket</a>);
		} else {
			return (<a href={"/addscreening/" + movie_id} className="btn btn-success btn-lg" >Add Screening</a>);
		}
	}

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
									onError={(current) => {
										current.onError=null;
										current.src='m.media-amazon.com/images/M/MV5BYzA0ZmFkMjQtNTVlYS00MzVkLWEyOGUtNTYxOWMyN2M5YWY5XkEyXkFqcGdeQXVyNjU0NTI0Nw@@._V1_UX512_.jpg';
									}}
								></img>
								{switchManager(movie.movie_id)}
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