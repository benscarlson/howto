
#----------------#
#---- colors ----#
#----------------#

#coolors. site to build color palette: https://coolors.co/def2c8-ff101f-7c90db-c5dac1-bcd0c7

col=rainbow(length(x)) #rainbow palette for base R plot. x is a vector.

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
