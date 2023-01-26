
#----------------#
#---- colors ----#
#----------------#

#coolors. site to build color palette: https://coolors.co/def2c8-ff101f-7c90db-c5dac1-bcd0c7
#Color Mind. http://colormind.io/ AI-driven color palettes.
#Canva. https://www.canva.com/ Web-based desktop publishing ?
#Colormind. http://colormind.io/ Extract color palette from image
#Met Brewer. https://github.com/BlakeRMills/MetBrewer
#Wes Anderson Colors. https://github.com/karthik/wesanderson
#http://tools.medialab.sciences-po.fr/iwanthue/
#https://visme.co/blog/color-combinations/

#---- refs ----#
# Color theory: https://www.smashingmagazine.com/2010/02/color-theory-for-designer-part-3-creating-your-own-color-palettes/


cols=rainbow(length(x)) #rainbow palette for base R plot. x is a vector.
cols=terrain.colors(length(x)) #terrain colors

#---- ggsci ----#
#https://nanx.me/ggsci/articles/ggsci.html
#Has color palettes for popular journals and sci-fi shows

#---- viridis ----#
viridis::viridis(12)

#Turbo, An Improved Rainbow Colormap for Visualization
#https://ai.googleblog.com/2019/08/turbo-improved-rainbow-colormap-for.html

#Three color packages: https://www.datanovia.com/en/blog/top-r-color-palettes-to-know-for-great-data-visualization/

#---- RColorBrewer ----#
pal <- brewer.pal(n = length(hvs), name = "Dark2") #
pal <- colorRampPalette(brewer.pal(n=12, name = "Paired"))(length(hvs)) #Use color ramp if too many items

#----------------#
#---- ggplot ----#
#----------------#

#--- default colors ---#

#This emulates ggplot colors:
#https://stackoverflow.com/questions/8197559/emulate-ggplot2-default-color-palette

#However, scales library has hue_pal() which also returns the palette
library(scales)
hue_pal()(3)

#can use show_pal to look at colors
show_col(hue_pal()(3))


#----

scale_color_brewer(palette='Dark2') #This is loaded with ggplot no need to load RColorBrewer package

#---- Setting manual colors ----#

#-- Discrete scale --#

scale_color_manual(values=c('#0073C2FF','#FC4E07')) #Passes colors on to scale_color_discrete()

#Note setting manual colors and applying to multiple aesthetics
cols <- c('random'='#0073C2FF','actual'='#FC4E07')
ggplot(gdat,aes(x=abs(diff),fill=diff_type,color=diff_type,..scaled..)) +
  geom_density(alpha=0.5) +
  scale_fill_manual(values=cols,aesthetics=c('color','fill'))

#-- Continous scale --#

#create a three part color gradient
scale_color_gradient2('Legend title',low="red", mid='green', high='blue',
  midpoint=median(x),
  breaks=c(1,2,3,4),
  labels=c('one','two','three','four'))

#---- Color Palette Packages ----#

#-- viridis --#
library(viridis)

scale_color_viridis(discrete=TRUE) #for factor, omit discrete for continuous
scale_colour_viridis_d() #Use with discrete data
scale_fill_viridis_c() # Use viridis_c with continous data
scale_fill_viridis_b() # Use viridis_b to bin continuous data before mapping

#-- wes anderson --#
# Stretch out a 5 color palette to 20 levels
# But this still returns a vector of colors so it can be used on a discrete scale
# if there are 20 levels in the data
wes_palette("Rushmore1",20,type='continuous')

#figure out breaks and format based on data. 
#this is how ggplot internally figures out breaks
#https://stackoverflow.com/questions/38486102/how-does-ggplot-calculate-its-default-breaks
rng <- range(as.numeric(gdat$timestamp))
breaks <-labeling::extended(rng[1], rng[2], m = 5) #note won't display the first and last items
labels <- as.Date(as.POSIXct(breaks,origin='1970-01-01',tz='UTC'))

p + scale_fill_gradient('Timestamp',low = "grey", high = "blue", breaks=breaks, labels=labels)

#use dates with viridis. column is called: date. Need to set trans='date'
scale_fill_viridis_c(option='plasma',trans='date')

#---- Examples of figures with nice palettes ----#

#https://advances.sciencemag.org/content/6/9/eaax8329?rss=1

#-------------------------#
#---- Manual palettes ----#
#-------------------------#

#This appears to be the color palette from ggradar
# "#FF5A5F", "#FFB400", "#007A87", "#8CE071", "#7B0051","#00D1C1", "#FFAA91", "#B4A76C", "#9CA299", "#565A5C", "#00A04B", "#E54C20"
