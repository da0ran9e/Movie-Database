const express = require("express");
const app = express();
const cors = require("cors");
const pool = require("./db");

// Middleware
app.use(cors());
app.use(express.json());	// req.body for POST and PUT


// ROUTES //

app.use("/auth", require("./routes/jwtAuth"));
app.use("/dashboard", require("./routes/dashboard"));
app.use("/manager", require("./routes/manager"));
app.use("/getuser",require("./routes/getuser"));


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
		var text = "SELECT * FROM get_films();"

		// Women's Day Special
		const womenDay = new Date('2000-03-08');
		const today = new Date();

		if (today.getMonth() === womenDay.getMonth() 
			&& today.getDate() === womenDay.getDate()){
			text = `SELECT * FROM Movie 
					WHERE title ~* 'women|woman|lady|mother|mom|female|miss '
					AND age_restriction != 'R' 
					ORDER BY release_date DESC;`;
		}
		// Women's Day Special

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

app.get("/movie/:id", async (req, res) => {
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

app.post("/screenings", async (req, res) => {
	try {
		// 1. Destructure
		const { movie_id, select_day } = req.body;
		console.log("Test: ");
		console.log(select_day);

		// 2. Get Screening
		const queryRoom = "SR JOIN Room R ON SR.room_id=R.room_id";
		const allScreen = await pool.query("SELECT * FROM client_get_screening($1, $2) " + queryRoom + ";", [movie_id, select_day]);

		res.json(allScreen.rows);
	} catch (err) {
		console.error(err);
		console.error(err.stack);
	}
});

app.get("/seats/:screen_id", async (req, res) => {
	try {
		// 1. Destructure
		const { screen_id } = req.params;

		// 2. Get Seat
		const allSeat = await pool.query("SELECT * FROM client_get_seat_all($1)", [screen_id]);
		const bookedSeat = await pool.query("SELECT * FROM client_get_seat_booked($1)", [screen_id]);

		allSeat.rows.forEach(seat => {
			if (bookedSeat.rows.some(booked => booked.seat_id === seat.seat_id)) {
				seat.book = 1;
			} else {
				seat.book = 0;
			}
		});

		res.json(allSeat.rows);
	} catch (err) {
		console.error(err);
		console.error(err.stack);
	}
});

app.get("/price/:screen_id", async (req, res) => {
	try {
		// 1. Destructure
		const { screen_id } = req.params;

		// 2. Get Price
		const dayPrice = await pool.query("SELECT * FROM client_get_price($1)", [screen_id]);

		res.json(dayPrice.rows[0].client_get_price);
	} catch (err) {
		console.error(err);
		console.error(err.stack);
	}
});

app.post("/purchase", async (req, res) => {
	try {
		// 1. Destructure
		const { screen_id, buy_tickets, user_id, email } = req.body;
		console.log(buy_tickets);
		console.log(screen_id);
		console.log(user_id);
		console.log(email);
		console.log("---");

		// 2. Insert into ticket
		const queryInsert = "SELECT * FROM book_ticket($1, $2, $3);";
		var valueInsert = [];

		if (user_id !== null) {
			valueInsert = [user_id, screen_id];
		} else {
			if (!email){
				return res.status(401).json("Missing Email");		
			}
			valueInsert = [email, screen_id];
		}

		for (let i = 0; i < buy_tickets.length; i++) { 
			valueInsert.push(buy_tickets[i]);
			// [user_id / email, screen_id, seat_id]
			const inserted = await pool.query(queryInsert, valueInsert);
			console.log(valueInsert);
			valueInsert.pop();

			if (inserted.rows.length === 0){
				return res.status(400).json("INPUT ERROR, PAUSED AT TICKET #" + (i+1));
			}
		}

		res.json(1);
	} catch (err) {
		console.log(err.message);
		res.status(500).send("Server Error");
	}
});



app.listen(5000, () =>{
	console.log("server has started on port 5000");
});