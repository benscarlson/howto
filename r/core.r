#---- Libraries ----#
detach(package:mylibrary) #this will remove mylibrary from the environment

#---- R system ----#

.Machine$double.eps # = 2.220446e-16. This is the smallest number x in which x + 1 != 1
getOption('contrasts') # shows default option for how factor coefficients are displayed. 'contr.treatment' sets one factor as control (0) and other factors as relative to this control.
Sys.info()['user']

#---- data types ----

# atomic
integer, numeric, logical, character

.Machine$integer.max #this is the maximum value of an integer

# more complex
Date, factor, matrix, list, data.frame

#---- vectors ----
v <- c(1,2,3)
names(v) <- c('one','two','three') #add names to vector elements. used names(v) to retrieve

cumsum(1:3) #this computes the cumulative sum in to a vector -> (1 3 6)
Reduce(sum,1:4) #--> 10. sumulatively applies function sum to each item in vector 1:4.

paste("a","b","c") # --> "a b c"
paste("A", 1:3, sep = "") #"A1" "A2" "A3"
paste("A", 1:3, sep = ":") #"A:1" "A:2" "A:3"

which(is.na(x)) #identify the index of missing values in a vector

quantile(c(1,2,3,4),probs=c(0,0.5,1)) # Finds quantile values given the provided probs (i.e. bins).
#0%: 1.0, 50%:2.5, 100%:4.0. I think this can be read as i.e. 0% of data is < 1.0, 50% is < 2.5, 100% is < 4.0
cut(c(1,2),breaks=c(1,2)) #makes factor level for groups based on breaks.
# <NA>, (1,2]. First groups is values -inf < x < 1, second group is 1 <= x <= 2. Note groups don't be consistent w/ boundary conditions!

#---- factors ----

#creates a factor. order of levels is based on the 'levels' attribute
factor(c(1,2,1,1),levels=c(1,2))
factor(c(1,2,1,1),levels=c(2,1)) #changes order of levels
factor(c(1,2,1,1),levels=c(2,1),labels=c('two','one')) #adds labels to levels
factor(c(1,2,1,1),levels=c(99,1),labels=c('two','one')) #levels and labels will match. here, '2' will have NA b/c no level exists for it.
factor(c('A','B'),levels=c('B','A'))

#order of factor levels defaults to alphabetical
f <- as.factor(rep(c('A','B'),10))
levels(f) # "A" "B"
levels(f) <- c('B','A') #change order of factor levels

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
file.path(path,to,file) #create a path out of path, to, and file
read.csv(file.choose()) #use file.choose() to read in a file
dir.exists('my/path')
dir.create('my/path',recursive=TRUE)
basename('my/file/path') #returns 'path'
dirname('my/file/path') #returns 'my/file'
fileN <- sub('\\.csv$','', basename('my/file/path.csv'), ignore.case=TRUE) #returns 'path'

shell.exec("myfile.txt") #have the operating system open myfile.txt using the default application

#---- data frames ----
#create an empty dataframe
data.frame(a=character(),b=numeric(),stringsAsFactors = FALSE)

#identify which rows in a dataframe have NA values
df <- data.frame(a=rnorm(10),b=rnorm(10))

#treat df like a list. all return vector b
df[[2]]
df[['b']]
df$b

#treat df like a matrix. all return vector b
df[,2]
df[,'b']

df = data.frame(x=c(1,NA,3,4,5), y=c(6,7,NA,9,10))
which(!complete.cases(df)) #--> 2 3

df[which(!duplicated(df$timestamp)), ] #remove duplicate timestamps from df

#make a table that summarizes each row of a dataframe      
round(t(do.call(cbind, 
  lapply(dat, summary ))),3) %>%
  View()

#unlist can turn a one row data frame into a vector
d <- data.frame(a=c(1,2), b=c(3,4))
class(d[1,]) #'data.frame'
class(unlist(d[1,])) #'numeric'

#---- lists ----
unlist(lapply(mylist,function(item) {item@Name})) #make a vector out of all Name attributes

#filters the lists for objects with @Name attribute = val1 or val2
mylist[
  unlist(lapply(mylist, function(item) 
    {item@Name %in% c('val1','val2')}))]

#---- built in constants----
LETTERS, letters, month.abb, month.name, pi

summary(m)$sigma #standard deviation of mean regression value

#---- strange functions ----
x<-5
eval("x") # --> prints "x"
as.symbol("x") # --> prints x
eval(as.symbol("x")) #--> prints 5 

#get() will resolve a string into a function
sin(pi/2) #--> 1
get('sin')(pi/2) #--> 1

#---- save r objects ----
saveRDS(object,path) #save an object to an RDS file 

#infix operators
5 %in% 1:5 #TRUE

`%s%` <- function(x,y) x + y
1 %s% 2 #3
      
### *apply ###
a<-1:3
sapply(1:3,function(i) {a[i]}) #returns vector 1 2 3
sapply(1:3,function(i,b) {b[i]}, b=a) #can also pass in variable and assign locally
      
t<-ToothGrowth
tapply(t$len,list(t$dose,t$supp),mean) #make a two way table of the means of each group
      
#---- random numbers ----
      
#set seed will propogate downward into functions. calling myf1 will make myf2 always return the same values
myf2 <- function() {return(sample(5))}
myf1 <- function() {set.seed(1);return(myf2())}

#---- introspection ----
methods(plot) #find out all commands available for generic function plot
methods(class='data.frame') #see all methods available for a particular class
help(data.frame) #read the section 'value' to learn about the return type from a function
args(plot) #find out the arguments of a plot



#---- other stuff ----
df <- data.frame(a=rnorm(10000),b=rnorm(10000),c=rep('x',10000))
digest(df,algo='sha1') #make a digest. Algo can be many different things.

#supress output from functions
sink("/dev/null"); p <- myfunct() ; sink()
p <- suppressMessages(myfunct())
p <- invisible(myfunct())



#---- bitwise operations ----#
strtoi('001000',base=2) #=8. convert bit string to integer

#check if a bit is turned on
on <- strtoi('101110',base=2)
mask <- strtoi('001000',base=2)
bitwShiftR(bitwAnd(on,mask),3)

# convert an integer to bit vector or string
bitVec <- function(int) {
  return(as.integer(rev(intToBits(int)[1:16])))
}

bitStr <- function(int) {
  paste(bitVec(int),collapse='')
}

strtoi(bitStr(1346),base=2) # ==> 1346
