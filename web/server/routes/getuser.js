const router = require("express").Router();
const pool = require("../db");
const jwt = require("jsonwebtoken");

router.post("/", async (req, res) => {
	try {
		const jwtToken = req.header("jwt_token");

		if (!jwtToken) {
			return res.json(0);
		}

		// Check valid jwt
		const payload = jwt.verify(jwtToken, 'jwtTest');
		res.json(payload.user);
	} catch (err) {
		console.error(err.message);
		res.status(403).json("TOKEN INVALID");
	}
});

module.exports = router;