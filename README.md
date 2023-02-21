# Movie Database
A move database project for database class IT3290E
HUST
[Final Report](https://docs.google.com/document/d/11-n5uiSzpTiDRPM0NfHfQpganTWKHJtr_gmEIPgeUJk/)

Edit this README.md using [`markdown`](https://www.markdownguide.org) language.


## Environment
Node.js

Follow instructions to install Node Version Manager (nvm):
- [For windows](https://github.com/coreybutler/nvm-windows)
- [For linux](https://github.com/coreybutler/nvm-windows)

Activate nvm in `/web/server` (or follow instruction provided in the links):
```
nvm install latest
nvm on
```

1. In directory `/web/server` run Windows Powershell, with command:
	```
	npm install
	node index.js
	```

2. In directory `/web/client` run another Windows Powershell, with command:
	```
	npm install
	npm start
	```

3. Edit the user, password and database name in `/web/server/db.js`
	```js
	const Pool = require("pg").Pool;

	const pool = new Pool({
		user: "user_name",
		password: "password",
		host: "localhost",
		port: 5432,
		database: "database_name"
	});

	module.exports = pool;
	```

4. Load all data into postgres with PSQL command in the root folder `/mdb`:
	```
	\i load-all.sql
	```

## Credits & References
Movie Dataset: https://www.kaggle.com/datasets/rezaunderfit/48k-imdb-movies-data

Customer Dataset: https://www.briandunning.com/sample-data

Password Dataset: https://www.kaggle.com/datasets/shivamb/10000-most-common-passwords

## Using the program
### Viewing the schema models
The diagram for the database model can be viewed using the files ending in `.erdplus`  

Go to https://erdplus.com/ to sign up for an account. From the navigation bar, go to Documents > Import, then import the downloaded `.erdplus` file. Upon successful upload, the diagram should be ready to view.

Another way of doing this is to create the database first as follows. Then right-click the created database and choose "Generate ERD" from the dropdown menu to view the diagram inside PgAdmin4.

### Initialize the database
To create the database, open PgAdmin4, type in your master password, right click the side bar and choose "Create new database" from the dropdown menu.

Right click on the newly created database, choose Query Tools and open the files ending in `.sql` from this repository.

Run them according to this order: 
```
movie-create.sql
movie-alter.sql
contraint_in_mdb.sql
triggers_in_mdb.sql
user_function.sql
manager_function.sql
```

To proceed, head on to the subfolder `proj` and follow the README there to import the data.
