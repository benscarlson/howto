
#---- extracting substrings ----
stringr::str_extract('123ABC','\\d+') #will extract '123'. seems to work better than gsub
stringr::str_sub('123ABC',1,3) #First three chars '123'
stringr::str_sub('123ABC',-3,-1) #Third from last to last 'ABC'

sub('([^ ]+)_(\\d{4}$)','\\1','Adi_2_2017') #will print out the first matched group
