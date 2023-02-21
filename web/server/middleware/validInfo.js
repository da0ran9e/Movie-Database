module.exports = function(req, res, next) {
	const { name, email, phone, email_phone, password } = req.body;

	function validEmail(userEmail) {
		return /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(userEmail);
	}

	if (req.path === "/register") {
		if (![name, password].every(Boolean)) {
			return res.status(401).json("Missing Credentials");
		} else if (![email, phone].some(Boolean)) {
			return res.status(401).json("Missing Email/Phone");
		} else if (email && !validEmail(email)) {
			return res.status(401).json("Invalid Email");
		}
	} else if (req.path === "/login") {
		if (!email_phone) {
			return res.status(401).json("Missing Email/Phone");
		} /* else if (email && !validEmail(email)) {
			return res.status(401).json("Invalid Email");
		} */
	}

	next();
};
