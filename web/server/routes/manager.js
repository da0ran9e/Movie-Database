const router = require("express").Router();
const pool = require("../db");

router.post("/addmovie", async (req, res) => {
	try {
		const user = await pool.query("SELECT * FROM Movie", [req.user]);

		res.json(req.user);
	} catch (err) {
		console.log(err.message);
		res.status(500).send("Server Error");
	}
});

router.post("/addscreening", async (req, res) => {
	try {
		// 1. Destructure req.body
		const { screen_date, start_time, room_id, movie_id } = req.body;
/*
	screen_id serial PRIMARY KEY,
	screen_date date NOT NULL,
	start_time time NOT NULL,
	available_seat integer NOT NULL DEFAULT 150,
	room_id integer NOT NULL,
	movie_id integer NOT NULL
*/

		if (!screen_date) {
			return res.status(400).json("Date Not Chosen");
		} else if (!start_time) {
			return res.status(400).json("Time Not Chosen");
		} else if (!room_id) {
			return res.status(400).json("Room Not chosen");
		}

		// 2. Insert
		const queryInsert = `INSERT INTO Screening (screen_date, start_time, room_id, movie_id)
												VALUES ($1, $2, $3, $4) RETURNING *;`
		const valueInsert = [screen_date, start_time, room_id, movie_id];
		const inserted = await pool.query(queryInsert, valueInsert);
		if (inserted.rows.length === 0){
			return res.status(400).json("INPUT ERROR");
		}

		res.json({value: 'Success'});
	} catch (err) {
		console.log(err.message);
		res.status(500).send("Server Error");
	}
});




module.exports = router;