
#nice example of heat map and a bunch of other best practices for ggplot2
#https://rud.is/projects/facetedheatmaps.html

#to use a string as column names. http://bit.ly/2tBvVMR
aes_string()

geom_text_repel(data=dat, aes(x=lon, y=lat,label=study_num),size=3,force=3) + #segment.color = NA (use this to turn off lines) 

#---- color ----#

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

# The order that items are drawn on the plot is based on the order of the data frame. 
#   The first item is drawn first and the last item drawn last.

#---- axes ----

#-- axis limits
xlim(0,100) #limit scale from 0 to 100
scale_x_continuous(limits=c(0,100)) #limit scale from 0 to 100

scale_x_continuous(expand=c(0,0)) #this removes padding between axis and data

#-- formatting
scale_x_continuous(labels=number_format(accuracy = 1, big.mark='')) #formats numbers to have no decimal place

scale_x_date() #this is prints out dates on axis

#---- mapping aethetics ----

#to manually set mappings, use scale_*_manual(). This assumes that var1 and var2 are factors with two levels
ggplot(data=dat, aes(x=x,y=y, alpha=var1, shape=var2)) +
  geom_point() +
  scale_shape_manual(values=c(3,16)) + 
  scale_alpha_manual(values=c(0.2,1))
    
#---- Themes ----
theme_classic() #this theme usually works fine
theme_tufte(base_family="Helvetica") #library(ggthemes)

#http://docs.ggplot2.org/dev/vignettes/themes.html
theme_set(theme_bw()) #sets theme to theme_bw for every plot in r session



#theme with no grey background, black lines for axes
theme_bw() +
theme(panel.border = element_blank(), panel.grid.major = element_blank(),
  panel.grid.minor = element_blank(),
  axis.line.x = element_line(color="black", size = 0.5),
  axis.line.y = element_line(color="black", size = 0.5))

#theme that looks similar to the above theme
plotTheme <-   theme(panel.background = element_blank(),
                     panel.grid.major = element_blank(), 
                     panel.grid.minor = element_blank(),
                     axis.text=element_text(size=20),
                     axis.title=element_text(size=20),
                     axis.line = element_line(colour = "black"),
                     legend.text = element_text(size=12),
                     legend.title = element_text(size=14))

# Use this theme for maps in presentations
theme_map <- theme(
  panel.background = element_blank(),
  panel.grid.major = element_blank(), 
  panel.grid.minor = element_blank(),
  #axis.line = element_line(colour = "black"),
  axis.ticks = element_blank(),
  axis.text = element_text(size=18), #element_blank(),
  axis.title = element_text(size=20), #element_blank(),
  legend.key = element_blank(),
  legend.text = element_text(size=16),
  legend.title = element_text(size=18))

#roate axis text
theme(axis.text.x = element_text(angle = 45, hjust = 1))

#----
#---- Guides/legends ----
#----

#-- legend title
labs(color='My Legend Title')

#--- Remove legends

# Several different methods. See: https://stackoverflow.com/questions/35618260/remove-legend-ggplot-2-2
guides(fill=FALSE)
geom_point(..., show.legend=FALSE)

#--- legend appearance

scale_color_discrete(name='My legend title') #use this if the legend variable is mapped to 'color' in aes()

guides(colour = guide_legend(override.aes = list(shape=16,size=3))) #override legend size and shape. 16 is filled circle.

guide_legend(ncol=2) #make 2 column legend. need to use guides() or scale_*_*() to set guide_legend (see above line).

theme(legend.background = element_rect(color='black',size=0.3)) #put a black box around legend

#set legend font size
theme(
  legend.text = element_text(size = 8),
  legend.title = element_text(size = 10))

theme(legend.key = element_blank()) #remove the boxes around  the legend shapes


#set labels on the 
scale_fill_continuous(
  labels=c(0,0.25,0.5,0.75,1))

#--- legend position

#put legend on the bottom. guide_colorbar() is for continuous, while guide_legend does discrete.
  guides(fill=guide_colorbar(
    title.position='top',
    label.position='bottom'))

#set the legend position first is x, second is y. for y, top is 1, bottom is 0
theme(legend.position = c(.8, .8), legend.key = element_blank())

#-- themes for faceting
theme(strip.text = element_text(size=9)) #change font size on facets

#---- PCA ----#
https://github.com/vqv/ggbiplot

#-----
# multipanel plots
#-----

#check out patchwork: https://www.r-bloggers.com/how-to-plot-with-patchwork/
# https://github.com/thomasp85/patchwork/blob/master/README.md

#-- Faceting
facet_grid(vars(population),vars(term),scales='free_y',switch='y',space='free_y')
facet_wrap(vars(group)) #one facet per group
#-----
# color palettes
#-----

#http://tools.medialab.sciences-po.fr/iwanthue/
#https://visme.co/blog/color-combinations/

#----------
# cowplot
#----------

#to set a blank theme, just use plot_grid. it will automatically set the theme to blank/classic

#legends can really throw off plot_grid. It seems that legends aren't scaled correctly. 
# so, the legend will be unscaled (often too big) and then the rest of the figure will be scaled
# to fit the default size. This results in a figure that is way to small. To get around this, specifically 
# set the base_width and base_height parameters in save_plot. Get the graph the way you want it,
# then play around with the size of the legend by using theme(). Finally, make final adjustments to base_width and base_height

save_plot('~/scratch/dualplot.png', dualPlot,
          ncol = 2, nrow = 1,
          base_width=8,
          base_height=6)
