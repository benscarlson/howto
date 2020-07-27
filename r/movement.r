#-------------#
#---- amt ----#
#-------------#

library(amt)

#See coded example from bioarxiv. Can be found in Zotero
#https://cran.r-project.org/web/packages/amt/vignettes/p1_getting_started.html
#https://cran.r-project.org/web/packages/amt/vignettes/p4_SSF.html

#---- workflow for single animal rsf ----#

dat %>% make_track(lon, lat, timestamp, crs = sp::CRS("+init=epsg:4326")) #make an track_xyt
dat %>% make_track(lon, lat, crs = sp::CRS("+init=epsg:4326")) #make a track_xy

trk %>% transform_coords(sp::CRS('+init=epsg:3035'))

#default is to sample from MCP around points. Bg is 10x presenses. Note flat projectin required due to sf.
# also results in a "random_points" object, not track_xy!
trk %>% random_points 

#Plotting tracks. case_ is after using random_points()
ggplot(trk,aes(x=x_,y=y_,color=case_)) + geom_point()

#--------------------#
#---- adehabitat ----#
#--------------------#

# adehabitatHR - Homeranges
# adehabitatHS - Habitat selection
# adehabitatLT - animal tracks and track analysis
# adehabitatMA - maps

# class is ltraj
# time not included in points - type I trajectories
# time is included with points - type II trajectories
# constant time lag - regularly sampled trajectory
# variable time lag - irregularly sampled trajectory
#--------------#
#---- move ----#
#--------------#

timestamps(mv) #get the timestamps of a move object
timeLag(mv, units = 'mins')
distance(mv) #returns vector of distances (in meters, for lon/lat) between points. vector length is one less than the number of points.
angle(mv) #returns vector of angles between points. length is one less than number of points.
