#---- references ----#
#https://cougrstats.wordpress.com/2018/04/30/mapping-in-r/

#---- Base R Maps ----#
raster::scalebar(1000, type='bar', divs=4)

### plotting polygons ###
splancs::polymap(mymatrix) #plot a polygon for a [,2] matrix

#---- making maps ----#
#https://www.r-bloggers.com/zooming-in-on-maps-with-sf-and-ggplot2/ #tricks to zooming into regions using ggplot and sf

library(rnaturalearth) #get administrative and country boundaries
rnaturalearth::ne_countries() #get country borders

#make a scale bar. Need to have columns named "long" and "lat".
  scalebar(data=rename(gdat,long=x,lat=y), dist=25, dd2km=TRUE, model='WGS84',location='bottomleft',
    st.size=3, height=0.02) +

#use x.min, etc. to manually set the bounds. scalebar is placed relative to this box. note here data=NULL
  ggsn::scalebar(data=NULL,
      dist = 50, dd2km = TRUE, model = 'WGS84', location='bottomleft',
      height=0.03, st.size=3, st.dist=0.05, st.color='white', #st.color requires dev version ggsn
      x.min=bb['x.min'], x.max=bb['x.max'], y.min=bb['y.min'], y.max=bb['y.max'])

#---- ggmap ----

#to use ggmap with sf, have to set inherit.aes=FALSE
ggmap(m) +
  geom_sf(data=popBox,inherit.aes = FALSE,aes(color=population))

#-- api key
#need to have development version of ggmap

#Example static maps call:
#https://maps.googleapis.com/maps/api/staticmap?center=waco+texas&zoom=12&size=640x640&scale=2&maptype=terrain&key=<mykey>

#Check api usage?
#https://console.cloud.google.com/google/maps-apis/overview?onboard=true&project=research-1537904108006&consoleUI=CLOUD

#3D maps
#https://blog.revolutionanalytics.com/2018/09/raytracer.html
