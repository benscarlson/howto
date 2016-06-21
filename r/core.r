cumsum(1:3) #this computes the cumulative sum in to a vector -> (1 3 6)
rm(tmp) #unload object tmp from memory
missing(x) #in a function, check to see if x has been passed in as a parameter

#get the numeric levels for a factor
treat <- as.factor(rep(c("A","B"),each=2))
as.numeric(treat) # [1] 1 1 2 2

class(x) #check the class of object x
typeof(x) #determines the (R internal) type or storage mode of any object

file.choose() #open a file dialog
read.csv(file.choose()) #use file.choose() to read in a file

which(is.na(x)) #identify the index of missing values in a vector

#identify which rows in a dataframe have NA values
d = data.frame(x=c(1,NA,3,4,5), y=c(6,7,NA,9,10))
which(!complete.cases(d)) #--> 2 3

Reduce(sum,1:4) #--> 10. sumulatively applies function sum to each item in vector 1:4.

matrix(1:6, ncol=2) #make a matrix with two columns

#built in constants:
LETTERS, letters, month.abb, month.name, pi

summary(m)$sigma #standard deviation of mean regression value

x<-5
eval("x") # --> prints "x"
as.symbol("x") # --> prints x
eval(as.symbol("x")) #--> prints 5 

t<-ToothGrowth
tapply(t$len,list(t$dose,t$supp),mean) #make a two way table of the means of each group

R CMD BATCH test.R #run file test.R from the command line
