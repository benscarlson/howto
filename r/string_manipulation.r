trimws(s) #remove whitespace

trimws(str_replace_all(s, '[\r\n]',' ')) #remove linebreaks from s

#---- extracting substrings ----
stringr::str_extract('123ABC','\\d+') #will extract '123'. seems to work better than gsub
stringr::str_sub('123ABC',1,3) #First three chars '123'
stringr::str_sub('123ABC',-3,-1) #Third from last to last 'ABC'

sub('([^ ]+)_(\\d{4}$)','\\1','Adi_2_2017') #will print out the first matched group

#if string is comma seperated, can just split
str_split(s,',')

#---- reverse string ----
stringi::stri_reverse('123ABC') 

# Neustadt a.d.Aisch-Bad Windsheim -> Neustadt a.d. Aisch-Bad Windsheim 
str_replace('Neustadt a.d.Aisch-Bad Windsheim','(^.+ a\\.d\\.)(.)','\\1 \\2')
