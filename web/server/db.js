const Pool = require("pg").Pool;

const pool = new Pool({
	user: "postgres",
	password: "q12Q!@",
	host: "localhost",
	port: 5432,
	database: "testdrive_8"
});

module.exports = pool;