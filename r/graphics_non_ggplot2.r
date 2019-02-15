
#http://gforge.se/2013/02/exporting-nice-plots-in-r/
#http://bit.ly/2JrDbRW. Producing a vector graphics image (i.e. metafile) in R suitable for printing in Word 2007


#---- base graphics ----
plot(data,col=data$myvar) #color by another variable
text(data,labels=data$myid, cex= 0.7) #add labels to a plot
lines(data) #add lines to a plot
box() #draw a box around a plot

#how to specify particlar pch values (here 13 & 19) for a vector.
obs <- c(0,1,1,0) #0=absence, 1=presence
pch=c(13,19)[obs+1] #do +1 because the symbol vector is 1 based.

#-- colors
col=rainbow(length(x)) #rainbow palette for base R plot. x is a vector.

#---- base histograms ----

# adding a large number of breaks will apparantly change  a hist from "frequency" to "probability density". Compare:
hist(density[density<200]) #density is the name of the variable
hist(density[density<200],breaks=c(0,seq(1,201,by=4)))

lines(density(density[density<200],from=0)) #add kernel density line to a histogram

prob=TRUE/FALSE; freq=TRUE/FALSE #seems can use either of these to specify prob dens/frequency.
#probability density means the area of each bar is proportional to the number of counts.

#----

plot(density(rnorm(100))) #plot smooth density of a vector
plot(jitter(x),jitter(y)) #jitter plot
image()
countour()
persp() #3d plots

asp=1 #use in base plot to fix aspect ratio to 1
