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

--- Delete data with on delete cascade enabled
--- Need to activate foreign keys, they are disabled by default in sqlite3
sqlite3 $db "PRAGMA foreign_keys = ON; delete from session where ses_name = \"${sesnm}\";"

-----------------------
---- Create tables ---- 
-----------------------

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

--# Create a copy of a table
 create table outlier_old as
	select * from outlier
	
----------------------
---- primary keys ----
----------------------

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

----------------------
---- Foreign keys ----
----------------------

-- if a table references a column other than a primary key as a foreign key,
-- that column needs to have a unique constraint or unique index.

---------------------
---- Alter table ----
---------------------

-- add a column with a foreign key constraint to an existing table
-- can do "add column x" or just "add x"
alter table hv_set add column pop_id integer references population (pop_id);

-- can drop columns as of 3.38, but not in current version (3.12) of DB Browser. Use sqlite3 instead
alter table hv_set drop my_column

-- can rename columns as of 3.25 (?)
alter table hv_set rename my_column to my_column2

--Renaming a table (as of version 3.26.0) will also rename the foreign key constraints in other tables that refer to the renamed table
--But this can be turned off with legacy_alter_table=ON. Also need to turn foreign keys off
PRAGMA foreign_keys=OFF
PRAGMA legacy_alter_table=ON

alter table forage_seg rename to forage_seg_old

--when renaming a table, you need to drop and recreate the indices, since these refer to the old table
drop index idx_forage_seg_1;
drop index idx_forage_seg_2;

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

-- .import will load empty csv fields as empty strings (''). So, need to set these to null afterwards.
update event_test set lst = NULL where lst='';

PRAGMA foreign_keys         --check if foreign keys are enabled
PRAGMA foreign_keys = ON;   --Turn on
PRAGMA foreign_keys = OFF;  --Turn off

-- to insert data into a table that has an autoincrement pk
-- first, create a temp table (with col1, col2)
-- then, create the target table (with pk, col1, col2)
-- finally, insert from temp into target
INSERT INTO fd_stats(pk, col1, col2) 
SELECT NULL,* FROM fd_stats_temp;

-------------------
----- Updating ----
-------------------

--UPDATE FROM syntax
--requires > SQLite version 3.33.0 (2020-08-14)
--if executing in DB Browser, requires DB Browser version >=3.12.2 (did not work for version 3.12.0)
--cant use alias for update table. can use alias for from table
-- note dont need table name on column that is being set
update event_forage
set study_id = i.study_id
from individual i
where i.individual_id = event_forage.individual_id

-- Can also UPDATE FROM using a subquery
 update hv_set
 set spec = hv.spec
 from ( 
	 select hs_id, avg(spec) as spec
	 from hypervol
	 where ses_id = 3 and level = 'hv'
	 group by hs_id) hv
 where hv_set.hs_id = hv.hs_id
 
------------------
---- Deleting ----
------------------

-- can't do delete ... join syntax, instead do delete ... in and select pks
delete from deployment
where deployment_id in (
	select deployment_id from deployment d
	inner join individual i on d.individual_id = i.individual_id
	where i.taxon_canonical_name = 'Tadorna tadorna')

---------------------
---- Performance ----
---------------------


-- Using computed year with an index was ~10x faster than dynamically deriving year

---- Indexes ----

-- Some sources say that you need to list conditions in the where clause in the same order as the index in order for sqlite to use the index. 
--  But that does not appear to be true as of verion 3.12.2

-- Min & Max
-- Using min(mycol) in the select clause will also use an index if available, but explain query plan won't report that it is being used
-- Some information warns against using min & max in the same statement. But, this doesn't seem to matter if using group by.

-- Count(*) does not seem to incur any performance costs
-- median() from the extensions package is extremely slow for large datasets

-------------------------
----- configuration -----
-------------------------

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

---- DB Browser ----

-- Settings
-- Data Broswer
--  Font: Andale Mono
--  Font size: 11
-- SQL
--  SQL editor font: Lucidia Grande
--  SQL editor font size: 15
--  SQL results font size: 15

---- Loading extensions ----

-- Example includes compiling and loading extension-functions.c, which has median()
-- https://www.cafe-encounter.net/p3244/installing-and-using-sqlite-extensions-on-macos-and-maybe-windows-linux-too


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

strftime('%Y-%m-%dT%H:%M:%SZ',timestamp) as timestamp -- format timestamps for earthengine to ingest

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

