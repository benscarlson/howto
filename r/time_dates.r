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

#can set format to convert to POSIXct
as.POSIXct('2007-10-12T00:30:00.000Z', format='%Y-%m-%dT%H:%M:%S', tz='UTC') 

#these are the same thing
s1 <- as.POSIXct('2017-09-07 00:00:00', tz='US/Eastern')
s2 <- as.POSIXct('2017-09-07', tz='US/Eastern')
identical(s1,s2) #TRUE

.POSIXct(as.integer(Sys.time()),tz='UTC') #This converts timestamp to UTC

strftime() #returns a character string. make sure to specify timezone, or local system timezone is assumed!
strftime('2017-04-27',format='%Y-%m-%dT%TZ', tz='UTC') #standard format

# %T and %H:%M:%S are the same thing
# Note sure how strftime and format are different
strftime(strTS,format='%Y-%m-%dT%T', usetz=TRUE, tz='US/Eastern')
strftime(strTS,format='%Y-%m-%dT%H:%M:%S', usetz=TRUE, tz='US/Eastern')
strftime(strTS,format='%Y-%m-%dT%H:%M:%S', tz='US/Eastern') #usetz prints out the tz in the result: 2014-06-01T03:20:11 UTC
format(x, "%Y-%m-%d %H:%M:%OS3", tz='UTC') #%OS says print milliseconds. %OS3 means print 3 decimal places

#convert from unix epoch time
as.POSIXct(1417305600,tz='UTC',origin='1970-01-01') #always use origin as 1970-01-01
as.Date(as.POSIXct(1417305600,tz='UTC',origin='1970-01-01')) #Get just the data portion

as.POSIXct('2017-06-27', tz='US/Eastern') #class(): "POSIXct" "POSIXt" print(): '2017-06-27 EDT'. Not sure how it is figuring out it is EDT or EST.
as.Date('2017-06-27', tz='US/Eastern') # class(): "Date". print(): "2017-06-27"
OlsonNames() #get the names of timezones for the tz attribute

#---- More on milliseconds ----#

#If you want millisecond (.000) resolution, add .0005 to the timestamp before formatting
#I checked every value from .001 to .999 and the method of adding .0005 will return accurate timestamp
ts <- as.POSIXct('2013-06-11 10:01:01.001',tz='UTC')

strftime(ts,format='%Y-%m-%d %H:%M:%OS3',tz='UTC') #2013-06-11 10:01:01.000
strftime(ts+0.0005,format='%Y-%m-%d %H:%M:%OS3',tz='UTC') #2013-06-11 10:01:01.001

#--- ymd_hms and as.POSIXct are accurate at different times. Strange!
#So regardless of how POSIXct is constructed, need to use the .0005 trick when writing the value.

#ymd is acurate with .123 millis
ymd_hms('2016-01-15 06:07:56.123') %>% strftime(format='%Y-%m-%d %H:%M:%OS6',tz='UTC') #.123000
as.POSIXct('2016-01-15 06:07:56.123', tz='UTC') %>% strftime(format='%Y-%m-%d %H:%M:%OS6',tz='UTC') #.122999

#But as.POSIXct is accurate with .127 millies
strftime(d,format='%Y-%m-%d %H:%M:%OS6',tz='UTC') #2016-01-15 06:07:56.122999.
ymd_hms('2016-01-15 06:07:56.127') %>% strftime(format='%Y-%m-%d %H:%M:%OS6',tz='UTC') #.126999
as.POSIXct('2016-01-15 06:07:56.127', tz='UTC') %>% strftime(format='%Y-%m-%d %H:%M:%OS6',tz='UTC') #.127000

# Day of Year #

#R is 0 based for 
#2019 is not a leap year. So 0 = Jan 1 and 364 = Dec 31
# 365 is Jan 1, 2020!
as.Date(0, origin = "2019-01-01") #2019-01-01
as.Date(364, origin = "2019-01-01") #2019-12-31
as.Date(365, origin = "2019-01-01") #2020-01-01

#For leap-year, 365 is 12-31
as.Date(365, origin = "2020-01-01") #2020-12-31

#---- excel ----#
=TEXT(C2,"yyyy-mm-ddThh:MM:ssZ") #convert excel date to ISO formatted timestamp

#---- lubridate ----
# number of months (roughly) between two dates
interval(as.Date(timestamp1),as.Date(timestamp2)) %/% months(1) #%/% means integer division
interval(dte1, dte2)/years(1) #number of years between two dates
ydat(today()) #get day of year

#Number of seconds between two timestamps
#interval, time_length are both vectorized. difftime has to use map. these functions are about 6x faster than map/difftime
mutate(
      diff_s1=map2_dbl(timestamp,lag(timestamp),difftime,units='secs') #Note later timestamp goes first
      diff_s2=time_length(interval(lag(timestamp),timestamp),unit='second')) #Here later timestamp goes second

#---- timing ----
ptm <- proc.time() 
elapsed_min <- round((proc.time() - ptm)[3]/60,2) #elapsed time in minutes

elapsedTime <- function(ptm) {
  sec_tot <- (proc.time() - ptm)[3]
  min <- floor(sec_tot/60)
  sec <- round(sec_tot %% 60)
  print(sprintf('Completed in %s minutes, %s seconds',min,sec))
}

#-- another approach
diffmin <- function(t,t2=Sys.time()) round(difftime(t2, t, unit = "min"),2)

t1 <- Sys.time()
# do something
message(glue('Complete in {diffmin(t1)} minutes'))

t1 <- Sys.time()
# do something
t2 <- Sys.time()
message(glue('Complete in {diffmin(t1,t2)} minutes'))
