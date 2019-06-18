#---- base r ----

dts <- as.Date(character()) #initialize dts as an empty date vector.
POSIXct() #store date and time, as number of seconds since Jan 1 1970. Usually the best choice for storage
POSIXlt() #stores date and time as a list of elements
POSIXt() #virtual class that POSIXct and POSIXlt interit from.

attr(myts,'tzone') #extract timezone from myts
      
#GMT and UTC will always have the same time. However, UTC is a standard, while GMT is the actual timezone
# in practice the times are the same. https://www.timeanddate.com/time/gmt-utc-time.html
as.POSIXct('2014-09-14 19:45:09', tz='UTC') 
as.POSIXlt('2014-09-14 19:45:09', tz='UTC') 
as.POSIXct('2014-09-14 19:45:09') #This will assign the timezone to the current timezone as defined by the computer running the code

#these are the same thing
s1 <- as.POSIXct('2017-09-07 00:00:00', tz='US/Eastern')
s2 <- as.POSIXct('2017-09-07', tz='US/Eastern')
identical(s1,s2) #TRUE

.POSIXct(as.integer(Sys.time()),tz='UTC') #This converts timestamp to UTC

strftime() #returns a character string. make sure to specify timezone, or local system timezone is assumed!
strftime('2017-04-27',format='%Y-%m-%dT%TZ', tz='GMT') #standard format

# %T and %H:%M:%S are the same thing
strftime(strTS,format='%Y-%m-%dT%T', usetz=TRUE, tz='US/Eastern')
strftime(strTS,format='%Y-%m-%dT%H:%M:%S', usetz=TRUE, tz='US/Eastern')
strftime(strTS,format='%Y-%m-%dT%H:%M:%S', tz='US/Eastern') #usetz prints out the tz in the result: 2014-06-01T03:20:11 UTC

#convert from unix epoch time
as.POSIXct(1417305600,tz='UTC',origin='1970-01-01') #always use origin as 1970-01-01
as.Date(as.POSIXct(1417305600,tz='UTC',origin='1970-01-01')) #Get just the data portion

as.POSIXct('2017-06-27', tz='US/Eastern') #class(): "POSIXct" "POSIXt" print(): '2017-06-27 EDT'. Not sure how it is figuring out it is EDT or EST.
as.Date('2017-06-27', tz='US/Eastern') # class(): "Date". print(): "2017-06-27"
OlsonNames() #get the names of timezones for the tz attribute

#---- excel ----#
=TEXT(C2,"yyyy-mm-ddThh:MM:ssZ") #convert excel date to ISO formatted timestamp

#---- lubridate ----
# number of months (roughly) between two dates
interval(as.Date(timestamp1),as.Date(timestamp2)) %/% months(1) #%/% means integer division
interval(dte1, dte2)/years(1) #number of years between two dates
ydat(today()) #get day of year

#---- timing ----
ptm <- proc.time() 
elapsed_min <- round((proc.time() - ptm)[3]/60,2) #elapsed time in minutes

elapsedTime <- function(ptm) {
  sec_tot <- (proc.time() - ptm)[3]
  min <- floor(sec_tot/60)
  sec <- round(sec_tot %% 60)
  print(sprintf('Completed in %s minutes, %s seconds',min,sec))
}
