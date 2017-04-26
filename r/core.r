#---- vectors ----
v <- c(1,2,3)
names(v) <- c('one','two','three') #add names to vector elements. used names(v) to retrieve

cumsum(1:3) #this computes the cumulative sum in to a vector -> (1 3 6)
Reduce(sum,1:4) #--> 10. sumulatively applies function sum to each item in vector 1:4.

paste("a","b","c") # --> "a b c"
paste("A", 1:3, sep = "") #"A1" "A2" "A3"
paste("A", 1:3, sep = ":") #"A:1" "A:2" "A:3"

which(is.na(x)) #identify the index of missing values in a vector

#---- factors ----
#get the numeric levels for a factor
treat <- as.factor(rep(c("A","B"),each=2))
as.numeric(treat) # [1] 1 1 2 2

rm(tmp) #unload object tmp from memory
missing(x) #in a function, check to see if x has been passed in as a parameter

class(x) #check the class of object x
typeof(x) #determines the (R internal) type or storage mode of any object

#---- matrices ----
matrix(1:6, ncol=2) #make a matrix with two columns

#---- file system ----
file.choose() #open a file dialog
read.csv(file.choose()) #use file.choose() to read in a file
dir.exists('my/path')
dir.create('my/path',recursive=TRUE)

#---- data frames ----
#identify which rows in a dataframe have NA values
df = data.frame(x=c(1,NA,3,4,5), y=c(6,7,NA,9,10))
which(!complete.cases(df)) #--> 2 3

df[which(!duplicated(df$timestamp)), ] #remove duplicate timestamps from df

#built in constants:
LETTERS, letters, month.abb, month.name, pi

summary(m)$sigma #standard deviation of mean regression value

x<-5
eval("x") # --> prints "x"
as.symbol("x") # --> prints x
eval(as.symbol("x")) #--> prints 5 

R CMD BATCH test.r #run file test.R from the command line
R --slave -f test.r #also run from the command line

#unlist can turn a one row data frame into a vector
d <- data.frame(a=c(1,2), b=c(3,4))
class(d[1,]) #'data.frame'
class(unlist(d[1,]) #'numeric'

shell.exec("myfile.txt") #have the operating system open myfile.txt using the default application

#make a table that summarizes each row of a dataframe      
round(t(do.call(cbind, 
  lapply(dat, summary ))),3) %>%
  View()

saveRDS(object,path) #save an object to an RDS file 

#infix operators
`%s%` <- function(x,y) x + y
1 %s% 2 #3

### time and date ###
as.POSIXct('2014-09-14 19:45:09', tz='UTC')

### timing ###
ptm <- proc.time() 
elapsed_min <- round((proc.time() - ptm)[3]/60,2) #elapsed time in minutes
      
### *apply ###
a<-1:3
sapply(1:3,function(i) {a[i]}) #returns vector 1 2 3
sapply(1:3,function(i,b) {b[i]}, b=a) #can also pass in variable and assign locally
      
t<-ToothGrowth
tapply(t$len,list(t$dose,t$supp),mean) #make a two way table of the means of each group
