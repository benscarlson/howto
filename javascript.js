
//---- Dates/Times ----//
new Date() //current date
new Date(2019,0,1) //Jan 1 2019. Note month is 0-indexed, but day is not!
new Date(2019,0,365) //Create using doy. 365 is last day of year since 2019 is not a leap year and function is 1-indexed.

(new Date()).toString().split(' ')[1] //gets the name of the month
(new Date()).getDate() //gets the day number (1-indexed)
