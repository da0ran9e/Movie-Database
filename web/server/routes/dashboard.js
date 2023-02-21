const router = require("express").Router();
const pool = require("../db");
const authorization = require("../middleware/authorize");

router.post("/", authorization, async (req, res) => {
	try {
		const user = await pool.query("SELECT name FROM Customer WHERE user_id = $1", [req.user]);

		res.json(req.user);
	} catch (err) {
		console.log(err.message);
		res.status(500).send("Server Error");
	}
});

module.exports = router;