const router = require("express").Router();
const pool = require("../db");
const bcrypt = require("bcrypt");
const jwtGenerator = require("../utils/jwtGenerator");
const validInfo = require("../middleware/validInfo");
const authorization = require("../middleware/authorize");

// Register
router.post("/register", validInfo, async (req, res) => {
	try {
		// 1. Destructure req.body (name, email, phone, password)
		const { name, email, phone, password } = req.body;

		// 2. Check user exist (email/phone), throw error
		const existEmail = await pool.query("SELECT login_exist_user($1);", [email]);
		const existPhone = await pool.query("SELECT login_exist_user($1);", [phone]);
		// if user already exist or somnhth
		if (existEmail.rows.length > 0){
			return res.status(401).json("Email already taken.");
		}
		if (existPhone.rows.length > 0){
			return res.status(401).json("Phone already taken.");
		}


		// 3. Bcrypt user password
		const saltRound = 10;
		const Salt = await bcrypt.genSalt(saltRound);

		const bcryptPassword = await bcrypt.hash(password, Salt);


		// 4. Enter new user inside DB
		const queryUser = "INSERT INTO Customer (name, phone_number, email, password) VALUES ($1, $2, $3, $4) RETURNING *;";
		const valueUser = [name, phone, email, bcryptPassword];
		const newUser = await pool.query(queryUser, valueUser);


		// 5. Generating our jwt token
		const jwToken = jwtGenerator(newUser.rows[0].user_id);
		res.json({ jwToken });

	} catch (err) {
		console.error(err.message);
		res.status(500).send("Server Error");
	}
});

// Login
router.post("/login", validInfo, async (req, res) => {
	try {
		// 1. Destructure req.body
		const { email_phone, password } = req.body;

		// 2. Check user exist
		const user = await pool.query("SELECT * FROM login_exist_user($1);", [email_phone]);
		if (user.rows.length === 0){
			return res.status(401).json("PASSWORD OR EMAIL IS INCORRECT");
		} else if (user.rows.length > 1){
			return res.status(401).json("WTF LOGIN FAILED SINCE THERE ARE TWO SAME EMAIL/PHONE");
		}

		// 3. VALID PASSWORD
		const validPassword = await bcrypt.compare(password, user.rows[0].password);
		if (!validPassword) {
			return res.status(401).json("Password incorrect.");
		}

		// 4. Give jwt token
		const jwToken = jwtGenerator(user.rows[0].user_id);
		res.json({ jwToken });

	} catch (err) {
		console.log(err.message);
		res.status(500).send("Server Error");
	}
});


// Login
router.post("/verify", authorization, (req, res) => {
	try {
		res.json(true);
	} catch (err) {
		console.log(err.message);
		res.status(500).send("Server Error");
	}
});

module.exports = router;