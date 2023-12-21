
duckdb -readonly $db #Open in read-only mode. Does not lock the database.

#execute a file with sql statements
duckdb $db < $src/db/database.sql

#---- duckdb interpreter ----

show tables; #show all tables
