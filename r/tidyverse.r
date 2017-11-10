#---- tidyr ----

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

#
separate() #splits based on a delimiter
extract(niche_group1, c("short_name1", "year1"), '([^ ]+)_(\\d{4}$)',remove=FALSE) #uses regular expression to split

#---- readr ----

read_csv('my/path',col_types=cols()) # will not print out column types

#---------------#
#---- dplyr ----#
#---------------#

dat %>% summarise_each(funs(sum(is.na(.)))) #see how many na values are in each row

filter(!val %in% c('a','b')) #not in a, b
dat %>% filter(complete.cases(.)) #only keep complete cases (rows with no NA)
dat %>% distinct(x,y, .keep_all=TRUE) #remove duplicate x,y. take first unique row of x,y, keeping all other columns

#operate on a dataframe from group
lastLoess <- function(dat) {
  m <- loess(Value ~ YearX, dat, span=0.75) # dat[dat$Country==country,]
  
  #dplyr:do requires return to be a dataframe.
  return(as.data.frame(m$fitted[length(m$fitted)]))
}

#use dplyr to group the dataframe and apply the lastLoess function
labelPoints <- sub %>% 
  group_by(Country) %>%
  do(lastLoess(.))

#group dataset then apply a function to certain columns in each group
dat1 <- dat0 %>%
  group_by(col_a) %>%
  mutate_each(funs(myscale),-c(col_a)) #don't apply to col_a. NOTE: this is old method.

db0 %>% #This is new way to apply myscale function by column
  mutate_at(.vars=vars(-c(niche_group)), .funs=funs(myscale))

lead(colname,1); lag(colname,1) #shift column forward or backward by one

case_when() #like a switch statement that works inside mutate.

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

#combine columns by taking the first non-na value
dat %>% mutate(col=coalesce(col_a,col_b))
