cumsum(1:3) #this computes the cumulative sum in to a vector -> (1 3 6)
rm(tmp) #unload object tmp from memory
missing(x) #in a function, check to see if x has been passed in as a parameter

#get the numeric levels for a factor
treat <- as.factor(rep(c("A","B"),each=2))
as.numeric(treat) # [1] 1 1 2 2

class(x) #check the class of object x

file.choose() #open a file dialog
read.csv(file.choose()) #use file.choose() to read in a file

which(is.na(x)) #identify the index of missing values in a vector

#identify which rows in a dataframe have NA values
d = data.frame(x=c(1,NA,3,4,5), y=c(6,7,NA,9,10))
which(!complete.cases(d)) #--> 2 3


