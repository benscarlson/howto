#lubridate
interval(as.Date(timestamp1),as.Date(timestamp2)) %/% months(1) #%/% means integer division

POSIXct() #store date and time, as number of seconds since Jan 1 1970. Usually the best choice for storage
POSIXlt() #stores date and time as a list of elements
POSIXt() #virtual class that POSIXct and POSIXlt interit from.

attr(myts,'tzone') #extract timezone from myts
      
#GMT and UTC will always have the same time. However, UTC is a standard, while GMT is the actual timezone
# in practice the times are the same. https://www.timeanddate.com/time/gmt-utc-time.html
as.POSIXct('2014-09-14 19:45:09', tz='UTC') 
as.POSIXlt('2014-09-14 19:45:09', tz='UTC') 
as.POSIXct('2014-09-14 19:45:09') #This will assign the timezone to the current timezone as defined by the computer running the code

as.POSIXct('2017-06-27', tz='US/Eastern') #this will result in an object '2017-06-27 EDT'. Not sure how it is figuring out it is EDT or EST.
OlsonNames() #get the names of timezones for the tz attribute

strftime() #returns a character string. make sure to specify timezone, or local system timezone is assumed!
### timing ###
ptm <- proc.time() 
elapsed_min <- round((proc.time() - ptm)[3]/60,2) #elapsed time in minutes
