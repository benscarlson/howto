
library(DBI)
library(RSQLite)

db <- DBI::dbConnect(RSQLite::SQLite(), "data/database.db")

dbListTables(db)
dbListFields(db,'my_table')

#---- getting data ----#
pltb <- as_tibble(tbl(db, 'player'))

#---- inserting data ----#

#-- trick to insert into a table that has autoincrement pk fields
sumLong %>% 
  mutate(model_summary_id=NA) %>% #add PK column set to NA
  select(model_summary_id,everything()) %>% #move to the right position
  dbAppendTable(db, "model_summary", .)
