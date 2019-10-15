
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

dbExecute(db,sql) #use to execute query that does not return data (e.g. update)
dbSendQuery(db,sql) #can be used to update, but can also be used to make request need to clear result no matter what
dbClearResult(q) #need to clear response buffer after calling dbSendQuery

#---- updating data ----#

#updating is hard. need to update row by row
for(i in seq_len(nrow(rini))) {
  #i <- 1
  row <- rini[i,]
  sql <- glue_sql(
    "update indiv_vol 
    set rini={row$rini} 
    where niche_name={row$niche_name} 
    and hv_job_name={row$hv_job_name}",.con=db)
  
  af <- dbExecute(db,sql)
  
  #should update exactly 1 row, if not provide warning
  if(af != 1) message(glue('Warning, update for {row$niche_name} affected {af} rows'))
}

