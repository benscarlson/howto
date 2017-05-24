summary(df)
table(df$myfactor)
sapply(df,class) #get class of each column

#these are equivilant
na.omit(x)
x[complete.cases(x), ]
