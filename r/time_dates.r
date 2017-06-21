#lubridate
interval(as.Date(timestamp1),as.Date(timestamp2)) %/% months(1) #%/% means integer division
      
#GMT and UTC will always have the same time. However, UTC is a standard, while GMT is the actual timezone
# in practice the times are the same. https://www.timeanddate.com/time/gmt-utc-time.html
as.POSIXct('2014-09-14 19:45:09', tz='UTC') #store date and time, as number of seconds since Jan 1 1970. Usually the best choice for storage
as.POSIXlt('2014-09-14 19:45:09', tz='UTC') #stores date and time as a list of elements
as.POSIXct('2014-09-14 19:45:09') #This will assign the timezone to the current timezone as defined by the computer running the code

strftime() #returns a character string
### timing ###
ptm <- proc.time() 
elapsed_min <- round((proc.time() - ptm)[3]/60,2) #elapsed time in minutes
