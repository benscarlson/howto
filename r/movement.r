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

#Use random_points() for rsf, and random_steps() for ssf

#default is to sample from MCP around points. Bg is 10x presenses. Note flat projectin required due to sf.
# also results in a "random_points" object, not track_xy!
trk %>% random_points 

trk %>% random_steps

track_resample #does something like 

#This is a typical workflow for creating random steps for ssf. Assume single animal.
dat %>% 
  make_track(lon, lat, timestamp, crs = sp::CRS("+init=epsg:4326")) %>% #make an track_xyt
  track_resample(rate=minutes(2),tolerance=hours(4)) %>% #what does this do?
  filter_min_n_burst %>% #minimum number of samples per bursts. default is min_n=3
  steps_by_burst %>% #this must make steps based on bursts? i.e. will not make steps between bursts?
  random_steps %>% #number of random points. default is 10 
  mutate(stratum=paste(niche_name,step_id_,sep='_')) %>% #per Stephanie, stratum should be unique across individuals
  select(individual_id, niche_name, obs=case_, stratum, x=x2_,y=y2_,timestamp=t2_)

#Plotting tracks. case_ is after using random_points()
ggplot(trk,aes(x=x_,y=y_,color=case_)) + geom_point()

#--------------------#
#---- adehabitat ----#
#--------------------#

# adehabitatHR - Homeranges
# adehabitatHS - Habitat selection
# adehabitatLT - animal tracks and track analysis
# adehabitatMA - maps

#Hard to find vignette for adehabitatLT on the web. Instead use:
vignette('adehabitatLT')

# class is ltraj
# time not included in points - type I trajectories
# time is included with points - type II trajectories
# constant time lag - regularly sampled trajectory
# variable time lag - irregularly sampled trajectory

#--- create ltraj objects ---#

#note timestamp need to be a POSIXct object and data has to be a data.frame
#convert as needed
dat <- dat0 %>% 
  mutate(timestamp=as.POSIXct(timestamp, format='%Y-%m-%dT%H:%M:%S', tz='UTC')) %>%
  as.data.frame #needs to be a dataframe for xy to work

trk <- as.ltraj(xy=dat %>% select(lon,lat), 
  date=dat$timestamp, 
  id=dat$individual_id)
#Can also take proj4string, but this is just a property that stores the string. ltraj does not actually do anything with it.

#--------------#
#---- move ----#
#--------------#

timestamps(mv) #get the timestamps of a move object
timeLag(mv, units = 'mins')
distance(mv) #returns vector of distances (in meters, for lon/lat) between points. vector length is one less than the number of points.
angle(mv) #returns vector of angles between points. length is one less than number of points.
