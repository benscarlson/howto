#--------------------# 
#---- SF package ----#
#--------------------# 

#http://strimas.com/r/tidy-sf/
#http://pierreroudier.github.io/teaching/20170626-Pedometrics/20170626-soil-data.html

#---- making sf objects ----#

#-- example going from sfg to sf

#-- sfg
poly <- st_polygon(list(cbind(c(0,3,3,0,0),c(0,0,3,3,0)))) #poly is an sfg object

#-- sfc
#a list with additional attributes. also referred to as "geometry set"
# includes coordiante system
poly_sfc <- st_sfc(poly)

#-- sf
poly_sf = st_sf(st_sfc(poly,poly)) #from sfg objects

#---- Geometries ----#

#-- Linestring --#

#Turn point geometries into lines
# turning point geom into lines: https://github.com/r-spatial/sf/issues/321
lines <- dat %>% 
  st_as_sf(coords=c('lon','lat'),crs=4326) %>% 
  group_by(individual_id) %>% 
  summarize(do_union=FALSE,.groups='drop') %>%
  st_cast('LINESTRING') 

#---- make st_polygon from data frame

# single polygon. last row has to equal first row (i.e. should be closed)
dat %>% 
  as.matrix %>%
  list %>%
  st_polygon

pts <- st_as_sf(x=jun14, coords=c("lon", "lat"), crs=4326) # sf from data.frame
# sf round trip to/from wkt
wkt <- st_asewkt(poly1)
poly1 <- st_sf(st_as_sfc(wkt))

#alternative way to make sf
c2 <- st_sfc(poly,poly)
d2 <- data.frame(name=c('x','y'))
f1 <- st_sf(cbind(d2,c2)) #one way to make sf
f2 <- st_sf(d2, geometry = c2) #another way to make sf

#-- make a data.frame from an sf object

# This piped workflow is the same as the function below.
ptsbg %>%
  st_set_geometry(NULL) %>%
  bind_cols(
    ptsbg %>% st_coordinates %>% as_tibble)

#TODO: move this into github or bencmisc
#based on function that comes from here: https://github.com/r-spatial/sf/issues/231
sfc_as_cols <- function(x, names = c("x","y")) {
  stopifnot(inherits(x,"sf") && inherits(sf::st_geometry(x),"sfc_POINT"))
  ret <- sf::st_coordinates(x)
  ret <- tibble::as_tibble(ret)
  stopifnot(length(names) == ncol(ret))
  x <- x[ , !names(x) %in% names]
  ret <- setNames(ret,names)
  
  ret <- dplyr::bind_cols(x,ret)
  
  ret <- st_set_geometry(ret, NULL) #this removes geometry column and turns back into data frame
}

#set crs in piped workflow
pts %>% st_set_crs(3035) 

#change the geometry (if you have another sfc or geom list column)
pts %>% st_set_geometry(pts$geom2)

#-----------------------#
#---- Geoprocessing ----#
#-----------------------#

#--- Buffers

pts %>% st_buffer(pts$radius) #apply different radius to each point

#--- Sampling

# Sample within different polygons using and different number of points
buf %>% #Buf is a sf object with polygon geometries
  mutate(pts=map2(geometry,num,~{
    st_sample(.x,.y)
  })) %>%
  unnest(pts) %>%
  mutate(pts=st_sfc(pts)) #pts is now a second column that is a list of geoms


#sfc is like a list (or "set") of 1 or more geometries
sfc_centroid <- pts0 %>% #pts0 is an sf object
  st_bbox %>% #bbox object
  st_as_sfc %>% #sfc_POLYGON (a geometry set ("column") of sfc_POLYGON)
  st_centroid #sfc_POINT (a geometry set ("column") of sfc_POINT)

#same thing but not using piped workflow
sfc_centroid <- st_centroid(st_as_sfc(st_bbox(pts0))) #centroid is an sfc_POINT object

#st_coordinates returns a matrix of coordinates. I only have one point so get first row as a vector
centroid <- st_coordinates(sfc_centroid)[1,] #returns a named vector c(X=<lon>,Y=<lat>)

#---- spatial filters ----#

#select all points that are within a polygon
pts2 <- pts %>% st_join(poly,left=FALSE) #pts, poly must be sf objects. need to use left=FALSE

#---- other ----#
pts %>% st_union %>% st_convex_hull #make a convex hull, need to do st_union first

#---- bounding boxes ----#

#make a bbox shapefile from a set of sf points
dsn <- file.path(.pd,'data/lbg_bbox')
dir.create(dsn)
pts %>% st_bbox %>% st_as_sfc %>% st_write(file.path(dsn,'lbg_bbox.shp'))

#get bounding boxes for groups of points. Quite convoluted.
#https://stackoverflow.com/questions/54696440/create-polygons-representing-bounding-boxes-for-subgroups-using-sf/54699950#54699950
popBox <- pts %>% #pts is an sf object with a grouping column called population
  group_by(population) %>%
  nest() %>%
  mutate(bbox = map(data, ~st_as_sfc(st_bbox(.)))) %>% #resulting polygons have crs=4326
  mutate(geometry = st_as_sfc(do.call(rbind, bbox),crs=4326)) %>% #need to specify crs, b/c it gets dropped #geometry is is a "Geometry set with 3 features"
  select(-data, -bbox) %>% 
  st_as_sf()

#Get area of bounding boxes over sf objects
polys %>% #polys is an sf object
  nest(data=-population) %>% #nest creates a list column, each item is an sf object
  mutate(bbox = map(data,~{.x %>% st_bbox %>% st_as_sfc})) %>%
  mutate(area_km2 = map_dbl(bbox,st_area)/1e3^2)

#add area column to sf object, convert units to km2
polys0 %>% mutate(area_km2=set_units(st_area(.),km^2))

#get a bbox of points, buffer by 0.25 degrees, and create an extent object to clip a raster
box <- pts %>% st_bbox + c(-0.25,-0.25,0.25,0.25)
ext <- extent(as.numeric(box)[c(1,3,2,4)]) #values are in different order in an extent object

#convert raster extent to an sf bbox
box <- tree %>% extent %>% st_bbox %>% st_as_sfc
st_crs(box) <- 4326 #For some reason st_as_sfc(crs=4326) is not working, so need to set this seperately

#---- units ----#
units(x) <- with(ud_units, km^2) #Changes units to km^2 (x is in m^2)

