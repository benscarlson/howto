#-----------------------#
#---- Configuration ----#
#-----------------------#

library(DBI)
library(RSQLite)

RSQLite::initExtension(db)
#https://rdrr.io/cran/RSQLite/man/initExtension.html

#-------------------#
#---- Meta data ----#
#-------------------#

db <- DBI::dbConnect(RSQLite::SQLite(), "data/database.db")

dbListTables(db)
dbListFields(db,'my_table')

#------------------------#
#---- Selecting data ----#
#------------------------#

pltb <- as_tibble(tbl(db, 'player'))

#Note using !! operator to inject vector data into dbplyr request
indTb %>% filter(individual_id %in% !!unique(dat$individual_id))

dbGetQuery() #executes query, fetches data, and clears results

#alternative to dbGetQuery
dbSendQuery()
dbFetch()
dbClearResults()

#---- rowid ----#

#If primary key is not specified, pk is a hidden auto-increment column called rowid
#to select row id, use dbGetQuery
dbGetQuery(db,'select rowid, * from rpt')

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

#Using glue_sql with dynamic column names
cols <- c('a','b')
glue_sql('select {cols*} from t') #Does not work because results in 'a','b' which is returned as data
glue_sql('select {`cols`* from t') #Using backticks works because it does a quoted identifier "a", "b" which refers to a column.

#Get the last inserted row id
#be careful, sqlite can represent larger integers than R
# sqlite: 8 bytes, so 64 bit signed integer. 2^63 - 1 == 9223372036854775807
# r is 32 bit signed so 2e9 == 2147483647
'select last_insert_rowid() as id' %>% dbGetQuery(db,.) %>% as.integer

# use as.integer64 from the bit 64 package
# not sure if this really works, is RSQLite sending the value as 64 bit or does casting covert correctly?
bit64::as.integer64(dbGetQuery(db, "select last_insert_rowid()")[1,1])

#---- inserting data ----#

#-- trick to insert into a table that has autoincrement pk fields
# NOTE: don't need to do this! PK column still autoupdates if the column is not included
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
