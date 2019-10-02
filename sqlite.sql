sqlite3 path/to/database.db
.databases #show attached databases
.tables #show the tables

cat db.sql | sqlite3 database.db /* create a database and run db.sql to initialize it */

INTEGER PRIMARY KEY - This will reference the rowid, an autoincrementing integer that is automatically created 

--#### Create tables ####--
CREATE TABLE my_table (
  fd_stats_id INTEGER PRIMARY KEY,
  player_id INTEGER NOT NULL,
  pos TEXT NOT NULL,
  fppg REAL NOT NULL,
  
  FOREIGN KEY(player_id) REFERENCES player(player_id)
);

--import if file does not contain a file header
.import data/derived/player_table_init.csv player

--There is no flag to skip file header when importing. so, need to explicitly skip it
.import "|tail -n +2 data/derived/player_table_init.csv" player

.headers on     --display headers when running select statement
.schmea mytable --display table schema

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
