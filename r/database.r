
library(DBI)
library(RSQLite)

db <- DBI::dbConnect(RSQLite::SQLite(), "data/database.db")

dbListTables(db)
dbListFields(db,'my_table')

#------------------------#
#---- Selecting data ----#
#------------------------#

pltb <- as_tibble(tbl(db, 'player'))

dbGetQuery() #executes query, fetches data, and clears results

#alternative to dbGetQuery
dbSendQuery()
dbFetch()
dbClearResults()

#---- parameterized queries ----#

#Can use parameters directly with dbGetQuery
sql <- "select individual_id from individual where study_id = ?"
id <- 10157679
dbGetQuery(db, sql, params = list(id))

#Can't select using IN operator with dbGetQuery. Use glue_sql instead
sql <- "select study_id,individual_id from individual where study_id in ?"
id <- c(10157679,3807090)
dbGetQuery(db, sql, params = list(id)) #Fail

#Query using IN operator using glue_sql
id <- c(10157679,3807090)
sql <- "select study_id,individual_id 
  from individual 
  where study_id in ({id*})" %>% glue_sql
dbGetQuery(db, sql)

#---- inserting data ----#

#-- trick to insert into a table that has autoincrement pk fields
sumLong %>% 
  mutate(model_summary_id=NA) %>% #add PK column set to NA
  select(model_summary_id,everything()) %>% #move to the right position
  dbAppendTable(db, "model_summary", .)

#option 1
dbExecute(db,sql) #use to execute query that does not return data (e.g. update)

#option 2
dbSendStatement()
dbGetRowsAffected()
dbClearResult()

#can't do this but shouldn't, use option 1 or 2
dbSendQuery(db,sql) #can be used to update, but can also be used to make request need to clear result no matter what
dbClearResult(q) #need to clear response buffer after calling dbSendQuery

#----
#---- updating tables ----#
#----

#-- Use this approach! Update table using dataframe --#
# Some info here: https://cran.r-project.org/web/packages/RSQLite/vignettes/RSQLite.html

dat <- tibble(id=1:10,var1=rnorm(10))
rs <- dbSendStatement(db, 'update mytable set var1 = $var1 where id = $id') #parameter names should match column names
dbBind(rs,params=dat) #just pass in the full dataframe
dbGetRowsAffected(rs)
dbClearResult(rs)

#Older approaches update row by row
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

#This checks to see if foreign key constraint works
#This will fail
dbExecute(db,'PRAGMA foreign_keys=ON')
dbSendQuery(db, "DELETE FROM sensor")
sensor %>% mutate(tag_id=1) %>% dbAppendTable(db, "sensor", .)
#This should work
dbExecute(db,'PRAGMA foreign_keys=OFF')
dbSendQuery(db, "DELETE FROM sensor")
sensor %>% mutate(tag_id=1) %>% dbAppendTable(db, "sensor", .)

#---- Transaction management ----#
dbBegin(db)
dbRollback(db)
dbCommit(db)


#---- Errors ----#

# Error: database disk image is malformed
# Got this error. Did a transaction roll back.
# From commandline
PRAGMA integrity_check; #This returned a bunch of errors
VACUUM; #Run this then run integrity_check again and got a bunch of errors about indices on event table
REINDEX event; #Ran this and then integrity_check found no errors!
