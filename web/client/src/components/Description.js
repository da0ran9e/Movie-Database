import { React, Fragment, useState, useEffect } from "react";
import { useParams } from "react-router-dom";

const DescMovie = () => {
	const [movie, setCurrentMovie] = useState({
		movie_id: "",
		title: "",
		description: "",
		age_restriction: "",
		duration: {
			hours: 0,
			minutes: 0
		},
		release_date: "",
		poster_url: ""
	});
	const [genres, setCurrentGenres] = useState([]);
	const { movie_id } = useParams();

	async function getMovieById () {
		try {
			const res = await fetch("http://localhost:5000/movie/" + movie_id);
			var moviejson = await res.json();
			console.log(moviejson);

			setCurrentMovie(moviejson);
			setCurrentGenres(moviejson.genres);
		} catch(err) {
			console.error(err.message);
		}
	}

	useEffect(() => {
		getMovieById();
	}, [movie_id]);

	function stringTime (h, m) {
		var str = "";

		if (h > 1 || m > 1) {
			str += h*60 + m + " minutes";
		} else if (m === 1) {
			str += m + " minute";
		}

		return str;
	}
	
	return (
		<Fragment>
			<div key={movie.movie_id}>
				<img className="movie-poster-bg"
					src={movie.poster_url.replace(".jpg", "_UX512_.jpg")}
					alt={movie.movie_id}
					onError={({currentTarget}) => {
						currentTarget.src="/poster-error.png";
						currentTarget.onerror=null;
						currentTarget.style="object-position: 50% 73%;";
					}}
				></img>
				<div className="container">
					<div className="row pt-3">
						<h1>{movie.title}</h1>
					</div>
					<div className="row pb-2">
						{genres.map(g => (
							<div key={g} className="col-auto mx-1 badge rounded-pill text-bg-secondary">{g}</div>
						))}
					</div>
					<div className="row pb-2">
						<h4>Description</h4>
						<p>{movie.description}</p>
					</div>

					<div className="justify-content-start border-top border-bottom py-3">
						<div className="row">
							<div className="col-sm-2"><h5>Duration:</h5></div>
							<div className="col">{stringTime(movie.duration.hours,movie.duration.minutes)}</div>
						</div>
						<div className="row">
							<div className="col-sm-2"><h5>Release date:</h5></div>
							<div className="col">{(new Date(movie.release_date)).toDateString()}</div>
						</div>
						<div className="row">
							<div className="col-sm-2"><h5>Rating:</h5></div>
							<div className="col">{movie.age_restriction}</div>
						</div>
						<div className="row">
							<div className="col-sm-2"><h5>Casts:</h5></div>
							<div className="col">{movie.casts}</div>
						</div>
						<div className="row">
							<div className="col-sm-2"><h5>Director:</h5></div>
							<div className="col">{movie.director}</div>
						</div>
					</div>


				</div>
			</div>
		</Fragment>
	)
}

export default DescMovie;