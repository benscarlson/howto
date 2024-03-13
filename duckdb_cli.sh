
duckdb -readonly $db #Open in read-only mode. Does not lock the database.

#execute a file with sql statements
duckdb $db < $src/db/database.sql

#---- duckdb interpreter ----

show tables; #show all tables

#---- Load a csv file when a table has an auto-generating primary key

create table temp_tbl as from 
  read_csv_auto('~/projects/disdat_db/data/spp_exceptions.csv',
    header=true);
    
insert into spp_exceptions (spex_id,spid,origin,reason)
select nextval('seq_spex_id') as spex_id, spid, origin, reason
from temp_tbl;

drop table temp_tbl;
