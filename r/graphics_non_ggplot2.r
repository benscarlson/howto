
plot(data,col=data$myvar) #color by another variable
text(data,labels=data$myid, cex= 0.7) #add labels to a plot
lines(data) #add lines to a plot

plot(density(rnorm(100))) #plot smooth density of a vector

image()
countour()

asp=1 #use in base plot to fix aspect ratio to 1
