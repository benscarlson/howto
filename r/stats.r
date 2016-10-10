m <- lm(y~x)

predict(m,interval="confidence") #confidence intervals. default is two-sided 95%
predict(m,se.fit=TRUE) #standard errors
