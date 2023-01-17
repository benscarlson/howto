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

poly_sf <- st_sf(poly_sfc) #This creates an sf object from an sfc object

c(sfc1, sfc2) #concatenate two sfc objects into one sfc object

#-- sf
poly_sf = st_sf(st_sfc(poly,poly)) #from sfg objects

#-- Make a rectangle sfc from coordinates --

# Need to repeat the first coordinate at the end to close the polygon
coords <- rbind(
  c(10.557096544818195, 51.95006165421499),
  c(10.557096544818195, 51.35707374226688),
  c(12.238004747943195, 51.35707374226688),
  c(12.238004747943195, 51.95006165421499),
  c(10.557096544818195, 51.95006165421499))

poly <- st_polygon(list(coords)) #Coords need to be in a list to pass to st_polygon

polysfc <- st_sfc(poly,crs=4326)

#-- Combine sfc objects that are in a list

#Several different ways. All these create a single sfc object from a list of sfc objects
do.call(c,sfcs)
Reduce(c,sfcs)
purrr::reduce(x,sfcs)

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

# This is the most compact version of the function below.
pts %>%
  cbind(st_coordinates(.)) %>%
  st_set_geometry(NULL)

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

#How to convert points to polygon:

poly <- adat$edges %>% 
  as_tibble %>%
  arrange(x1) %>%
  st_as_sf(coords=c('x1','y1')) %>%
  st_combine %>%
  st_cast('POLYGON')

#-- Turn a tibble with a list-column of polygon objects into as sf object

# Make a tibble with a column of polygon objects. aPoly() returns st_polygon
x <- tibble(a=c(0.5,1,a,100)) %>%
  mutate(poly=map(a,~aPoly(ashape(dat0 %>% select(x,y),alpha=.x))))

# Now turn the column of polygons into an st_sfc column, and cast the tibble to an sf object
y <- x %>% 
  mutate(geometry=st_sfc(poly)) %>%
  st_sf

#-- How to plot each polygon to a seperate facet
ggplot(y) +
  geom_sf() +
  facet_wrap(vars(a))

#---- Writing to disk ----#

#This should work but is writing an additional comma after the final column name. Strange.
#Instead, convert to dataframe first then just write the csv.
pts %>% st_write(.outPF,layer_options = "GEOMETRY=AS_XY", delete_dsn=TRUE)
# X,Y,timestamp, <--- note additional comma
# 11.3190349598152,51.4117821494741,2019-08-09T10:05:44Z
# 11.6036340773717,51.4811973146424,2019-07-01T17:35:03Z

#write a geopackage. layer can be an arbitrary name. use append=FALSE to overwrite an existing file
pts %>% st_write(dsn='mypts.gpkg',layer='mypoints', append=FALSE)

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

#---- Union ----#
#st_union help text is confusing, but seems to work as expected with polygons.
border <- lkPoly %>% st_union %>% st_sf #note lkPoly is an sf but st_union outputs a geometry set, so need to turn back into sf

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
#can also turn it into an sfc to set crs in one pipeline
st_bbox %>% st_as_sfc %>% st_sf(crs=4326)

#Create an sf bbox using a dataframe with lon/lat columns
ptbb <- c(range(dat$lon),range(dat$lat))[c(1,3,2,4)] %>% 
  `names<-`(c('xmin', 'ymin', 'xmax', 'ymax')) %>%
  st_bbox(crs=4326)

#--- Convert terra SpatRaster bbox to sf bbox
#sf raster: xmin, ymin, xmax, ymax
#terra raster: xmin, xmax, ymin, ymax

ext(rterra) #(xmin, xmax, ymin, ymax)
st_bbox(as.vector(ext(rterra))[c(1,3,2,4)])

#---- units ----#
units(x) <- with(ud_units, km^2) #Changes units to km^2 (x is in m^2)

