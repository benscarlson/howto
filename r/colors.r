
#----------------#
#---- colors ----#
#----------------#

#coolors. site to build color palette: https://coolors.co/def2c8-ff101f-7c90db-c5dac1-bcd0c7

cols=rainbow(length(x)) #rainbow palette for base R plot. x is a vector.
cols=terrain.colors(length(x)) #terrain colors

#---- ggsci ----#
#https://nanx.me/ggsci/articles/ggsci.html
#Has color palettes for popular journals and sci-fi shows

#---- viridis ----#
viridis::viridis(12)

#Turbo, An Improved Rainbow Colormap for Visualization
#https://ai.googleblog.com/2019/08/turbo-improved-rainbow-colormap-for.html

#----------------#
#---- ggplot ----#
#----------------#

#Note setting manual colors and applying to multiple aesthetics
cols <- c('random'='#0073C2FF','actual'='#FC4E07')
ggplot(gdat,aes(x=abs(diff),fill=diff_type,color=diff_type,..scaled..)) +
  geom_density(alpha=0.5) +
  scale_fill_manual(values=cols,aesthetics=c('color','fill'))

#create a three part color gradient
scale_color_gradient2('Legend title',low="red", mid='green', high='blue',
  midpoint=median(x),
  breaks=c(1,2,3,4),
  labels=c('one','two','three','four'))

#-- viridis
scale_color_viridis(discrete=TRUE) #for factor, omit discrete for continuous

#figure out breaks and format based on data. 
#this is how ggplot internally figures out breaks
#https://stackoverflow.com/questions/38486102/how-does-ggplot-calculate-its-default-breaks
rng <- range(as.numeric(gdat$timestamp))
breaks <-labeling::extended(rng[1], rng[2], m = 5) #note won't display the first and last items
labels <- as.Date(as.POSIXct(breaks,origin='1970-01-01',tz='UTC'))

p + scale_fill_gradient('Timestamp',low = "grey", high = "blue", breaks=breaks, labels=labels)
