m <- lm(y~x)

predict(m,interval="confidence") #confidence intervals. default is two-sided 95%
predict(m,se.fit=TRUE) #standard errors

#Get the p-value for one-way anova
a <- aov(niche_vol~loc_label,data=gdat)
summary(a)
#p-value is buried. summary(a)[[1]] is a dataframe
pval <- summary(a)[[1]]['loc_label','Pr(>F)']
