To load data into database, first open PSQL Tool (Next to Query Tool when right-clicking)

1. Locate /proj folder and move the PostgreSQL server to there
---Helpful commands in PSQL

\! cd	: Check current working directory
\cd	: Change directory. Must use forward slash /
		(e.g.	\cd 'C:/Users/abc/Downloads')

2. Use this command to run the load-data.sql file

\i load-data.sql

3. If the data is loaded successfully, it will display

COPY 20
COPY 45433
COPY 91015