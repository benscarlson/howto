
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

#---- updating data ----#

#updating is hard. need to update row by row
for(i in seq_len(nrow(sqldat))) {
  #i <- 2
  row <- sqldat[i,]
  sql <- glue_sql(
    "update niche_set_vol 
    set nestedness={row$nestedness} 
    where niche_set={row$niche_set} 
    and hv_job_name={row$hv_job_name}",.con=db)
  q <- dbSendQuery(db,sql)
  
  dbClearResult(q) #need to clear response buffer or I get warning
}
