--Storage classes: null, integer, real, txt, blob

sqlite3 path/to/database.db
.databases #show attached databases
.tables #show the tables
.schema mytable #show schema information for mytable
.headers on     --display headers when running select statement

cat db.sql | sqlite3 database.db /* create a database and run db.sql to initialize it */

---- Run from bash ----

--# Save a query to csv
sqlite3 -header -csv c:/sqlite/chinook.db "select * from tracks;" > tracks.csv

sql="select study_id, individual_id, local_identifier, 1 as run \
from individual \
order by study_id, individual_id"

sqlite3 -header -csv $db "$sql;" > $wd/ctfs/individual.csv

--#Import csv into the database. note use of --skip 1 to skip the heaader row
sqlite3 -csv $db ".import --skip 1 data/outlier.csv outlier"

--#### ------------- ####--
--#### Create tables ####--
--#### ------------- ####--

--NOTES:
--  TEXT should be used for date, not NUMERIC
--  INTEGER is used for boolean

CREATE TABLE my_table (
  fd_stats_id INTEGER PRIMARY KEY,
  player_id INTEGER NOT NULL,
  pos TEXT NOT NULL,
  fppg REAL NOT NULL,
  
  FOREIGN KEY(player_id) REFERENCES player(player_id)
);

--#### primary keys ####--
--complicated in sqlite!
--A hidden column called rowid will be created if WITHOUT ROWID is not used. This is called a "row id" table
--If the table is a "row id" table, then using "mycol INTEGER PRIMARY KEY" makes mycol an alias to rowid
create table my_table (
  mycol INTEGER PRIMARY KEY --Just an alias to rowid
);

--If table is a "without row id" table, then PK is not an alias
create table my_table (
  mycol INTEGER PRIMARY KEY --Not an alias to rowid, because rowid is not created
) WITHOUT ROWID;

select rowid, * from mytable; --to see rowid (if it exists) add it to select list

--# Create a copy of a table
 create table outlier_old as
	select * from outlier
  
------------------------
---- Inserting data ----
------------------------

---- Using R DBI ----

-- for a date/time datatype in dataframe, DBI will insert a numeric value by default into sqlite, regardless of data affinity
-- if using dbi, probably best to convert to string manually.
-- using .import works as expected.

---- Importing csv files ----
.mode csv #need to set mode to csv

--import if file does not contain a file header
.import data/derived/player_table_init.csv player

--There is no flag to skip file header when importing. so, need to explicitly skip it
.import "|tail -n +2 data/derived/player_table_init.csv" player

-- Note .import will insert text date into db, if that is what is stored in csv, regardless of data affinity


PRAGMA foreign_keys         --check if foreign keys are enabled
PRAGMA foreign_keys = ON;   --Turn on
PRAGMA foreign_keys = OFF;  --Turn off

-- to insert data into a table that has an autoincrement pk
-- first, create a temp table (with col1, col2)
-- then, create the target table (with pk, col1, col2)
-- finally, insert from temp into target
INSERT INTO fd_stats(pk, col1, col2) 
SELECT * FROM fd_stats_temp;

-------------------
----- Updating ----
-------------------

--UPDATE FROM syntax
--requires > SQLite version 3.33.0 (2020-08-14)
--if executing in DB Browser, requires DB Browser version >=3.12.2 (did not work for version 3.12.0)
-- might not be able to use an alias for table that is being updated
-- try an alias using from table
-- note dont need table name on column that is being set
update event_forage
set study_id = individual.study_id
from individual
where individual.individual_id = event_forage.individual_id

----- configuration -----

--- this is from using brew upgrade. not macos comes with a version and that is the default
--- I used the first command to update path, but did not set the other commands.

/*
If you need to have sqlite first in your PATH run:
  echo 'export PATH="/usr/local/opt/sqlite/bin:$PATH"' >> ~/.bash_profile

For compilers to find sqlite you may need to set:
  export LDFLAGS="-L/usr/local/opt/sqlite/lib"
  export CPPFLAGS="-I/usr/local/opt/sqlite/include"

For pkg-config to find sqlite you may need to set:
  export PKG_CONFIG_PATH="/usr/local/opt/sqlite/lib/pkgconfig"
*/

---- Selecting ----

-- Take earliest timestamp per day --

select *, date(timestamp) as date 
from event 
where individual_id = 10666985
group by date
having min(timestamp)
order by date

---- Date/Time columns ----

cast(strftime('%Y',timestamp) as integer) -- extract year. have to cast to int if comparing to an integer

---- Filtering ----

-- can filter using computed column
where cast(strftime('%Y',timestamp) as integer) =  2015

---- Managing table structure ----

-- Change the table name - Use alter table statement
-- Add column - Use alter table statement
-- Change column name, column order - Use DB Browser

---#### Load extensions ####---

#https://stackoverflow.com/questions/6663124/how-to-load-extensions-into-sqlite
curl --location --output extension-functions.c 'https://www.sqlite.org/contrib/download/extension-functions.c?get=25'
gcc -g -fPIC -dynamiclib extension-functions.c -o extension-functions.dylib

