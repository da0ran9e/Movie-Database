import React, { Fragment, useState } from "react";

const InputMovie = ({movies, setMovies}) => {
	const [title, setTitle] = useState("");
	const [result, setResult] = useState(0);

	const onSubmitForm = async (e) => {
		e.preventDefault();	// Prevent refresh

		if (title === "") {
			setMovies([]);
			return;
		}

		try {
			const response = await fetch(`http://localhost:5000/search?term=${title}`);
			const movieArray = await response.json();

			setMovies(movieArray);
			setResult(movieArray.length);
		} catch (err) {
			console.error(err.message);
		}
	}

	return (
		<Fragment>
			<div className="container text-center">
				<h1 className="my-5">Movie Search</h1>
				<form className="d-flex my-3" onSubmit={onSubmitForm}>
					<input type="text"
						placeholder="Search Title..."
						className="form-control"
						value={title}
						onChange = {e => setTitle(e.target.value)}
					/>
					<button className="btn btn-success">Find</button>
				</form>
				{result ? <div className="text-start my-2">Found {result} result{result > 1 ? "s" : null}.</div> : null}
			</div>
		</Fragment>
	)
}


export default InputMovie;