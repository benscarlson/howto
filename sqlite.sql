sqlite3 path/to/database.db
.databases #show attached databases
.tables #show the tables
.schema mytable #show schema information for mytable
.headers on     --display headers when running select statement

cat db.sql | sqlite3 database.db /* create a database and run db.sql to initialize it */

--#### Create tables ####--
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

#---- configuration ----#

--- this is from using brew upgrade. not macos comes with a version and that is the default
--- I used the first command to update path, but did not set the other commands.

If you need to have sqlite first in your PATH run:
  echo 'export PATH="/usr/local/opt/sqlite/bin:$PATH"' >> ~/.bash_profile

For compilers to find sqlite you may need to set:
  export LDFLAGS="-L/usr/local/opt/sqlite/lib"
  export CPPFLAGS="-I/usr/local/opt/sqlite/include"

For pkg-config to find sqlite you may need to set:
  export PKG_CONFIG_PATH="/usr/local/opt/sqlite/lib/pkgconfig"
