
library(DBI)
library(RSQLite)

db <- DBI::dbConnect(RSQLite::SQLite(), "data/database.db")

dbListTables(db)
dbListFields(db,'my_table')
