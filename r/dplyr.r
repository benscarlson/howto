filter(!val %in% c('a','b')) #not in a, b

dat %>% filter(complete.cases(.)) #only keep complete cases (rows with no NA)

dat %>% summarise_each(funs(sum(is.na(.)))) #see how many na values are in each row

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
