#see: http://r4ds.had.co.nz/ (R for Data Science book)
#Quo/Enquo recipes: https://edwinth.github.io/blog/dplyr-recipes/

#---------------#
#---- tidyr ----#
#---------------#

stocks <- data_frame(
  X = rnorm(2, 0, 1),
  Y = rnorm(2, 0, 2),
)
#note there is no column in 'stocks' called 'stock' or 'price'. 
#stock is made up of the column headers. price is made up of the values.
stocks %>% gather(stock, price) 

#to have set of 'key' fields that don't get collapsed, use the syntax -key
stocks <- data_frame(
  key = 1,
  X = rnorm(2, 0, 1),
  Y = rnorm(2, 0, 2),
)
stocks %>% gather(stock, price,-key)

#another example. two columns, key, value columns will be created
# based on dist2urban, etc.
# the names of the column headers go into env_var
# the values in the respective columns go into env_val
gather(key=env_var,value=env_val,dist2urban,dist2water,pct_bare,pct_tree)

#
separate() #splits based on a delimiter
extract(niche_group1, c("short_name1", "year1"), '([^ ]+)_(\\d{4}$)',remove=FALSE) #uses regular expression to split

#-- nest

#seems these do the same things. nest() will respect group_by
# or, will make groups based on items that are not to be nested
dat %>% group_by(id) %>% nest()
dat %>% nest(-id) 

#---------------#
#---- readr ----#
#---------------#

#--- Reading csvs ---#

read_csv('my/path',col_types=cols()) # will not print out column types

#it seems timestamps are read assuming UTC timezone

#--- Writing csvs ---#

#Write na as "" instead of NA. It would be nice to be able to default this but I can't find a way.
write_csv(...,na="")

#Write timestamps in alternative format
#By default, timestamps are written like '2018-10-18T12:37:03Z'
#This sets the output format for timestamps for write_csv
#Github has an example using POSIXt but only POSIXct seems to work (https://github.com/tidyverse/readr/issues/745)
output_column.POSIXct <- function(x) {
  format(x, "%Y-%m-%d %H:%M:%OS3", tz='UTC')
}

#----------------#
#---- tibble ----#
#----------------#

#create row-wise data.frame
tribble(
  ~colA, ~colB,
  "a",   1,
  "b",   2,
  "c",   3
)

#create empty tibble
tibble(niche_name=character(),event=character())

#More general way to initial an empty tibble and write to csv
c('ses_id','num','minutes') %>% 
  purrr::map_dfc(~tibble::tibble(!!.x := character())) %>%
  write_csv('out.csv') #cat -e out.csv -> ses_id,num,minutes$

#In writing to csv, no need to go through tibble. Just write a string to file
c('ses_id','num','minutes') %>% 
  paste(collapse=',') %>% 
  write_lines(.outPF) #cat -e out2.csv -> ses_id,num,minutes$

#---------------#
#---- dplyr ----#
#---------------#

#---- Filtering ----#

#Complete cases for multiple variables
tibble(a=c(1,NA,1,NA),b=c(1,1,NA,NA),rep(NA,4)) %>%
  filter(across(c(a,b),~!is.na(.x)))

#-- Renaming columns --#
dat %>% rename_all(~str_replace_all(., "-", "_")) #replace all instances of '-' with '_'

#-- Selecting columns --#
dat %>% select(my_col,everything()) #move my_col to the front of the df.
dat %>% select(-my_col,everything()) #move my_col to the end of the df.

dat %>% summarise_each(funs(sum(is.na(.)))) #see how many na values are in each row

filter(!val %in% c('a','b')) #not in a, b
dat %>% filter(complete.cases(.)) #only keep complete cases (rows with no NA)
dat %>% distinct(x,y, .keep_all=TRUE) #remove duplicate x,y. take first unique row of x,y, keeping all other columns

#---- Mutating ----#

mutate(id=row_number()) #add row number as a column (good for unique id). CAREFUL! make sure to ungroup() or id will be wrong.
#-- scaling columns --#

#This is how to do scale using dplyr and the base r scale function
.vars <- vars(pct_tree,pct_bare,dist2urban,dist2water)
.vars <- c('pct_tree','pct_bare') #Also works

dat1 <- dat0 %>%
  group_by(niche_set) %>% #mutate_at will respect groups
  mutate_at(.vars=.vars,.funs=funs(as.vector(scale(.)))) 

#NOTE: this is the old mmethod for scaling columns
#group dataset then apply a function to certain columns in each group
dat1 <- dat0 %>%
  group_by(col_a) %>%
  mutate_each(funs(myscale),-c(col_a)) #don't apply to col_a.

#Assign date variable to bins
dat %>% mutate(bin=cut(as.Date(timestamp),'7 days'))

#---- working with columns ----#

#-- combine columns by taking the first non-na value --#
dat %>% mutate(col=coalesce(col_a,col_b))

#mutate to sum columns based on vector of column names
dat <- tibble(a=sample(rep(c(1,0),3)),
           b=sample(rep(c(1,0),3)),
           c=sample(rep(c(1,0),3)))
dat %>% mutate(num=rowSums(.[c('a','b')]))

#apply function to each column
dat %>% summarize_all(my_fun) #also look at summarize_at, summarize_if

#-- group_by/nest/map --#

#for map, it's not required that the function called return a data.frame
dat1 %>% group_by(short_name) %>% nest() %>% #makes list of data frames based on groups, store in 'data' column
  mutate(kde95=purrr::map(data, ~kde95(.))) %>% #apply kde95 function to each data frame in 'data' column. kde95 returns a data.frame
  unnest() #expand the nested kde95 dataframes

#nested function call, 
dat1 %>% group_by(short_name) %>% nest() %>%
  mutate(mycol=map(data, ~funA(funB(.))))

#can pass in data from multiple columns. refer to .x and .y inside the function
dat %>% mutate(x=map2(.x=col1,.y=col2, ~{.x + .y}))
#try out pmap to pass in n parameters

#---- other stuff? ----#

lead(colname,1); lag(colname,1) #shift column forward or backward by one

case_when() #like a switch statement that works inside mutate.

#---- Filtering ----#

#filter by multiple columns, multiple criteria
#we only want (1, 'a') and (3, 'b') i.e. don't want (2,'a')
dat <- data.frame(a=c(1,2,3,4,5), b=c('a','a','b','b','c'))
dat %>% filter(a %in% c(1,3) & b %in% c('a','b'))

#filter by number of items in group. take groups in which there are more than 100 rows.
dat %>% group_by(col1) %>% filter(n() < 100)

#subsample only groups that have more than a certain number of rows.
#use sample_frac() trick to permute
#https://stackoverflow.com/questions/30950016/dplyr-sample-n-where-n-is-the-value-of-a-grouped-variable
tSub <- tThin %>% 
  group_by(individual_id,yr) %>%
  sample_frac(1) %>% #this permutes the row, by group
  filter(row_number() <= 100) #take up to 100 rows in each group

#sort by group and then take the first item in each group
dat %>%
  group_by(individual_id,dte) %>%
  top_n(n=-1,wt=timestamp) %>% #-1 takes the first timestamp in the group

#subsample .npts rows from each group, but take all rows if n() < .npts
dat %>% slice_sample(n=.npts)

#---- group_by/do and group_by/nest/map ----#

#operate on a dataframe from group
lastLoess <- function(dat) {
  m <- loess(Value ~ YearX, dat, span=0.75) # dat[dat$Country==country,]
  
  #dplyr:do requires return to be a dataframe.
  return(as.data.frame(m$fitted[length(m$fitted)]))
}

#use dplyr to group the dataframe and apply the lastLoess function
#note for do(), the function must return a data.frame
labelPoints <- sub %>% 
  group_by(Country) %>%
  do(lastLoess(.))

#---- across/columnwise operations ----#

dat0 %>% mutate(across(c(x,y,z),~as.vector(scale(.x)))) #scales x,y,z

terms <- quo(c(x,y,z))
dat0 %>% mutate(across(!!terms,~as.vector(scale(.x)))) #use tidy evaluation to define columns

#---- Converting ----#

#-- Converting lists to dataframes 

#dflist is a list of dataframes (or tibbles).
# df_name is the name of the 'id' column. This is a column created that contains the 
# appropriate value from names(dflist)

bind_rows(dflist, .id='df_name')

#convert a tibble row to a vector
dat %>% slice(1) %>% unlist() #can also do unlist(use.names=FALSE) or unlist %>% uname

#pull out a column using [] syntax
dat %>% .[1] #takes column 1, this is the same as `[`(1). can also do e.g. .['event'] if it is a list

#-------------------------#
#---- tidy evaluation ----#
#-------------------------#

#note use of dynamic column name
envLab = 'my_col_name'
mutate(!!envLab := !!as.name(envLab)*0.0001)

#these also work
envNames <- c('env1','env2')
dat %>% select(!!envNames)

envName <- quo(dist2forest) #single term
envName <- quo(c(dist2forest,ndvi)) #multiple terms. note the use of c() within quo
dat %>% select(!!envName)

envName <- quo(!!sym('dist2forest'))
dat %>% select(!!envName)

#---------------#
#---- purrr ----#
#---------------#

#map or walk can use shortcut ~ instead of function(x). so these are all the same
map(lst, function(.) { print(.) }) #just like lapply
map(lst,~{ print(.)}) #just like above, but using ~ for function(.)
#map(lst, function(.) print(.) ) #just like lapply. commented b/c github syntax parser doesn't like
map(lst,~print(.)) #just like above, but using ~ for function(.)

#passing in parameters to function can be like this:
map(hv,hypervolume_thin,num.points=10)

#walk is like map, but does not return values. Use this if printing or plotting
walk(hvs@HVList,~{
  plot(.,show.density=FALSE,show.random=FALSE,show.data=FALSE)
  #print(.)
})

#extract items from lists
map(dat$listcol,`$`,'item1')

#extract items from S4 slots. All but `@` should also work on non-S4 object
# note S4 object can't select multiple 
map(hvs@HVList, 'RandomPoints') #works
map(hvs@HVList,`@`, 'RandomPoints') #works
map(hvs@HVList, pluck, 'RandomPoints') #works

map(mylist,`[`, 'col_a') #should work
map(mylist,`[`, c('col_a','col_b')) #should work. note can select multiple items

map_chr(hvs@HVList,'Name') #works. flattens the names into a vector

#extracts slot 'RandomPoints' and then converts each item to a tibble
hvs@HVList %>%
  map('RandomPoints') %>%
  map(as_tibble)

#this does the same thing as above
hvs@HVList %>% 
  map(~as_tibble(pluck(.,'RandomPoints'))) 

dat %>% mutate(a=map(obj,`$`,'slotname'))
dat %>% mutate(a=map(obj,pluck,'slotname')) #these do the same thing

#Pass in data to function where the function doesn't take the data as the first argument
#data should be first argument to map, use ~function syntax, and .x refers to data that is passed into map
dat %>% nest(data=-group) %>% mutate(a=map(data,~lm(x~y,data=.x)))

#map over each row in a dataframe.
#This uses pmap and sends the entire row into the function. The function captures all rows as a tibble
dat %>%
  mutate(result=pmap(.,function(...) {
    row <- tibble(...)
    rsf <- exp(rast2*row$tree) #example using the column "tree" from the current row
  }))

#---- purrr and lists
mylist %>% list_modify('event'=NULL) #removes the item 'event' from the list

mylist %>% iwalk(~write_csv(dfs[.y][[1]],.x,na="")) #version of map2 specific to lists. .y is the item name, .x is the value

#------------------#
#---- purrrlyr ----#
#------------------#

#NOTE: seems this approach is deprecated in favor of the nest/mutate/map approach
    
#this will return a column called cal_name with the results of the function, by row
library(purrrlyr)
dat %>%
  by_row(.to='col_name', ..f=function(row) {
    #row is a tibble with one row
    row2 <- row#do something to r
    return(row2)
  })

#if returning a dataframe
dat %>%
  by_row(function(row) {
    #row is a tibble with one row
    row2 <- tibble(x=1,y=2)
    return(row2)
  }) %>% unnest(.out)

#---- Forcats ----#
https://www.r-bloggers.com/cats-are-great-and-so-is-the-forcats-r-package/

#--------------------#
#---- multidplyr ----#
#--------------------#

#https://www.business-science.io/code-tools/2016/12/18/multidplyr.html
#https://cfss.uchicago.edu/notes/split-apply-combine/

