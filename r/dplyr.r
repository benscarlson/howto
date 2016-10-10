filter(!val %in% c('a','b')) #not in a, b

dat %>% filter(complete.cases(.)) #only keep complete cases (rows with no NA)

dat %>% summarise_each(funs(sum(is.na(.)))) #see how many na values are in each row
