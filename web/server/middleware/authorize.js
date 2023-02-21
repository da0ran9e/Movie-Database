const jwt = require("jsonwebtoken");

module.exports = async (req, res, next) => {
	try {
		// 1. Destructure
		const jwtToken = req.header("token");

		if (!jwtToken) {
			return res.status(403).json("YOU ARE NOT LOGGED IN");
		}

		// 2. Check valid jwt
		const payload = jwt.verify(jwtToken, 'jwtTest');
    	req.user = payload.user;
		// 3.
		next();
	} catch (err) {
		console.error(err.message);
		return res.status(403).json("TOKEN INVALID");
	}
}