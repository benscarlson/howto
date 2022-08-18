#---- references ----#
#https://cougrstats.wordpress.com/2018/04/30/mapping-in-r/
# Inset maps with ggplot2. https://geocompr.github.io/post/2019/ggplot2-inset-maps/

#Example of where I created a map
#https://gist.github.com/benscarlson/652f9048958bbd5fbb0175c1492cac6d

#Other guides:
#https://www.r-spatial.org/r/2018/10/25/ggplot2-sf.html

#---- data sources ----#
rnaturalearth
spData #https://nowosad.github.io/spData/ us states, world borders
urbnmapr #https://github.com/UrbanInstitute/urbnmapr. Shapefiles for US counties and states

#---- Base R Maps ----#
raster::scalebar(1000, type='bar', divs=4)

### plotting polygons ###
splancs::polymap(mymatrix) #plot a polygon for a [,2] matrix

#---- ggplot maps ----#
#https://www.r-bloggers.com/zooming-in-on-maps-with-sf-and-ggplot2/ #tricks to zooming into regions using ggplot and sf

library(rnaturalearth) #get administrative and country boundaries
rnaturalearth::ne_countries() #get country borders
ne_coastline(scale=110,returnclass='sf') #get coastlines

# method to clip map to size of pts/data layer
xlims <- range(pts$lon) * c(0.8,1.2)
ylims <- range(pts$lat) * c(0.5,1)

#can use lims or coord_sf. in one test, lims removed some points but coord_sf retained them. so maybe coord_sf is better
lims(x=xlims,y=ylims) #use lims argument in ggplot
coord_sf(xlim=xlims,ylim=ylims) #use coord_sf instead of lims. 
#---- Scale bars ----#

#-- make a scale bar using ggsn. Need to have columns named "long" and "lat".
  scalebar(data=rename(gdat,long=x,lat=y), dist=25, dist_unit='km', transform=TRUE, model='WGS84',location='bottomleft',
    st.size=3, height=0.02) +

#to use ggsn with ggmaps, need to figure out the bounds of the map, then set xmin, ... based on this.

mp <- get_map(...)
bb <- attr(mp,'bb')

#where to place map. play around with scaling to get scale put in right place.
xmin <- bb$ll.lon + (bb$ur.lon-bb$ll.lon)/15
xmax <- bb$ur.lon - (bb$ur.lon-bb$ll.lon)/15
ymin <- bb$ll.lat + (bb$ur.lat-bb$ll.lat)/10
ymax <- bb$ur.lat - (bb$ur.lat-bb$ll.lat)/10

ggsn::scalebar(data=NULL,
  dist = 10, dist_unit='km',transform = TRUE, model = 'WGS84', location='bottomleft',
  height=0.03, st.size=3, st.dist=0.05, st.color='white', #st.color might require dev version
  x.min=xmin, x.max=xmax, y.min=ymin, y.max=ymax)

# a second method is to make a datafram to supply to data parameter. still need to adjust xmin etc. values accordingly
bbdf <- data.frame(long=c(xmin,xmax),lat=c(ymin,ymax))

ggsn::scalebar(data=bbdf,
  dist = 10, dist_unit='km',transform = TRUE, model = 'WGS84', location='bottomleft',
  height=0.03, st.size=3, st.dist=0.05, st.color='white')

#-- make a scalebar using ggspatial

#Try it out: https://www.r-spatial.org/r/2018/10/25/ggplot2-sf.html

#----
#---- Labels ----
#----

geom_text_repel(aes(x=lon,y=lat,label=study_name),size=2) #ggrepel

#----
#---- ggmap ----
#----

#to use ggmap with sf, have to set inherit.aes=FALSE
ggmap(m) +
  geom_sf(data=popBox,inherit.aes = FALSE,aes(color=population))

#-- Google Maps static api
#need to enable this api in cloud console
#need to have development version of ggmap
#After 12-month trail, need to 'upgrade' account which will be subject to billing
#But, the cost looks low: https://developers.google.com/maps/documentation/maps-static/usage-and-billing
# $2 for 1000 requests, and there might be a $200 credit applied each month.
# See Notes for project id

#Example static maps call:
#https://maps.googleapis.com/maps/api/staticmap?center=waco+texas&zoom=12&size=640x640&scale=2&maptype=terrain&key=<mykey>

#Check api usage?
#https://console.cloud.google.com/google/maps-apis/overview?onboard=true&project=<project id>&consoleUI=CLOUD

#3D maps
#https://blog.revolutionanalytics.com/2018/09/raytracer.html

#----
#---- Quick map scripts ----#
#----

#ggplot script of points and coastlines

library(rnaturalearth) #get administrative and country boundaries

pts <- st_as_sf(...)
cl <- ne_coastline(scale=110,returnclass='sf') #get coastlines

ggplot() +
  geom_sf(data=cl) +
  geom_sf(data=pts) +
  geom_sf_text(data=pts,aes(label=name),size=2,nudge_y=-1) +
  coord_sf(
    xlim=st_bbox(pts)[c(1,3)] + c(-1,1),
    ylim=st_bbox(pts)[c(2,4)] + c(-1,1))

#---- ggmap of a movement track

source(rd('src/funs/ggmap_ext.r'))

mp <- ggmMap(gdat)

ggmap(mp) +
  geom_path(data=dat, aes(x = lon, y=lat), show.legend =FALSE, alpha=0.5, color='white') +
  geom_point(data=dat %>% sample_frac(1), size = 2, shape = 21, color='white', stroke=0.1,
    aes(x = lon, y = lat, fill=date)) + #, fill=individual_id)
  scale_fill_viridis_c(option='plasma',trans='date') +
  ggmScalebar(mp)

