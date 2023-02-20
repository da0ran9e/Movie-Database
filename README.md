# Movie Database
A move database project for database class IT3290E
HUST
[Final Report](https://docs.google.com/document/d/11-n5uiSzpTiDRPM0NfHfQpganTWKHJtr_gmEIPgeUJk/)

Edit this README.md using [`markdown`](https://www.markdownguide.org) language.


## Environment
pgAdmin4 
```sql
-- Code here on how to set up environment

SELECT E.install_instruction
FROM Environment E
WHERE Valid;
```

## Credits & References
Movie Dataset: https://www.kaggle.com/datasets/rezaunderfit/48k-imdb-movies-data\
Customer Dataset: https://www.briandunning.com/sample-data/\
Password Dataset: https://www.kaggle.com/datasets/shivamb/10000-most-common-passwords\

## Using the program
### Viewing the schema models
The diagram for the database model can be viewed using the files ending in `.erdplus`  

Go to https://erdplus.com/ to sign up for an account. From the navigation bar, go to Documents > Import, then import the downloaded `.erdplus` file. Upon successful upload, the diagram should be ready to view.

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
