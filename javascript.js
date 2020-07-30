
//---- Dates/Times ----//
new Date() //current date
new Date(2019,0,1) //Jan 1 2019. Note month is 0-indexed, but day is not!

(new Date()).toString().split(' ')[1] //gets the name of the month
(new Date()).getDate() //gets the day number (1-indexed)
