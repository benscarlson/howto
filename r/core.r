cumsum(1:3) #this computes the cumulative sum in to a vector -> (1 3 6)
rm(tmp) #unload object tmp from memory
missing(x) #in a function, check to see if x has been passed in as a parameter

#get the numeric levels for a factor
treat <- as.factor(rep(c("A","B"),each=2))
as.numeric(treat) # [1] 1 1 2 2

class(x) #check the class of object x


