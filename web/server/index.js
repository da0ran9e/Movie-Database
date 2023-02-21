const express = require("express");
const app = express();
const cors = require("cors");
const pool = require("./db");

//middleware
app.use(cors());
app.use(express.json());	// req.body


// ROUTES //

app.use("/auth", require("./routes/jwtAuth"));
app.use("/dashboard", require("./routes/dashboard"));

app.use("/manager", require("./routes/manager"));


app.get("/search", async(req, res) => {
	try {
		const searchTerm = req.query.term;

		const searchMovie = await pool.query("SELECT * FROM find_films($1);", [searchTerm]);
		res.json(searchMovie.rows);
	} catch (err) {
		console.error(err.message);
	}
});

// get all movie

app.get("/movies", async (req, res) => {
	try {
		const text = "SELECT * FROM get_films();"

		const allMovies = await pool.query(text);
		res.json(allMovies.rows);
	} catch (err) {
		console.error(err);
		console.error(err.stack);
	}
});

app.get("/rooms", async (req, res) => {
	try {
		const text = "SELECT * FROM Room;"

		const allRooms = await pool.query(text);
		res.json(allRooms.rows);
	} catch (err) {
		console.error(err);
		console.error(err.stack);
	}
});

app.get("/booking/:id", async (req, res) => {
	try {
		const { id } = req.params;

		const allMovies = await pool.query("SELECT * FROM Movie WHERE movie_id=$1;", [id]);
		const allGenres = await pool.query("SELECT * FROM get_genres($1);", [id]);
		const allDirectors = await pool.query("SELECT * FROM get_directors($1);", [id]);
		const allCasts = await pool.query("SELECT * FROM get_casts($1);", [id]);

		var strDir = "";
		var strCast = "";
		var arrGen = [];

		allGenres.rows.forEach(g => {arrGen.push(g.genre_name)});
		allDirectors.rows.forEach(p => {strDir += p.director_name + ", "});
		allCasts.rows.forEach(p => {strCast += p.cast_name + ", "});

		strDir = strDir.slice(0, -2) + '.';
		strCast = strCast.slice(0, -2) + '.';

		const mergedMovie = {
			...allMovies.rows[0], 
			genres: arrGen,
			director: strDir,
			casts: strCast
		};

		res.json(mergedMovie);
	} catch (err) {
		console.error(err);
		console.error(err.stack);
	}
});




app.listen(5000, () =>{
	console.log("server has started on port 5000");
});