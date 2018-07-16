#http://www.maths.lancs.ac.uk/~rowlings/Teaching/UseR2012/cheatsheet.html

#-----------------#
#---- rasters ----#
#-----------------#

env <- raster('misc/tinamus_env.tif') #read raster
writeRaster(env,'misc/tinamus_env.tif','GTiff') #write a raster to tif
writeRaster(stk, filename=rastPF, bylayer=TRUE, format="raster",overwrite=TRUE) #write a stack as individual layers

nlayers(mystack) #number of RasterLayers in the RasterStack
names(mystack) #the names of the RasterLayers in the RasterStack
extent(mystack) #extent of the RasterLayers in the RasterStack
mystack[[1]] #extract the first RasterLayer from the RasterStack
names(layer) <- 'layername' #set the name of RasterLayer to 'layername'
ncell(layer) #number of cells
calc(layer, function(x) { f(x) }) #apply function f to layer
cellStats(layer,sum) #returns the sum of all cells in layer. can also use mean, min, etc.
metadata(layer) <- metadata #adds metadata to layer
rdist_r@data@min;rdist_r@data@max #see min and max values for a rasterLayer
res(layer) #see the x,y resolution of the raster. get units from crs()
env_tif <- raster('misc/tinamus_env.tif') #load the raster from tif
raster::extract(env_rdata,pts,df=T,ID=F) #extract raster values given a set of points (here, a SpatialPoints object)
bbox(obj) #get the bounding box of spatial object obj

rast@legend #if populated, this can hold a colortable (or color ramp) that can be used for plotting
colortable(rast) #access to the colortable stored in rast@legend

#---- create a rat from colortable and labels file
# the colortable from the raster is 0-based (0 to 255), but R is 1-based (1 to 256)
# so, need to make ID from 0 to 255
ct <- colortable(rast)
ct1 <- data.frame(ID=0:(length(ct)-1),col=ct,stringsAsFactors=FALSE)
rat <- read_csv('~/path/to/labels.csv') %>%
  left_join(ct1,by='ID')
rat[rat$ID==0,]$col <- '#FFFFFF' #set NA value (0) to white
write_csv(rat,'~/path/to/rat.csv')

# create raster from scratch
refRast <- raster(extent(spdf1),crs=CRS(pars$flatProj)) #creates a raster with extent and projection
res(refRast) <- 30 #this sets the resolution of the raster
values(refRast) <- rnorm(ncell(refRast)) #set all values based on normal distribution

#project raster to another CRS
clc12_2utm <- projectRaster(from=clc12_2,crs=crs(pct_tree), method='ngb') #ngb is nearest neighbor


bareUtm <- projectRaster(from=pct_bare,crs=crs(pct_tree))
bareUtm <- resample(x=bareUtm,y=pct_tree) #need to resample to get back to 30,30 resolution

rast2 <- crop(rast,extent(pts),snap='out')

#---------------------#     
#---- Vector Data ----#
#---------------------#

#libraries that can read shapefiles. 'raster', 'shapefile', 'maptools' (?)

getGDALVersionInfo()

# reading shapefiles
shapefile('myshapefile.shp') #part of raster package. load shapefile into a SpatialPolygonsDataFrame
maptools::readShapePoints('myshpfile.shp') #maptools. also see readShapeLines
maptools::readShapeSpatial('myshpfile.shp')

#if shapefile is at my/path/myshape/shape.shp
readOGR(dsn="my/path/myshape", layer="shape")

#writing shapefiles
#make sure to create polys using a dataframe, not a tibble, otherwise writeOGR will give cryptic errors
writeOGR(obj=polys, dsn="shapefiledir", layer="shapefilename", driver="ESRI Shapefile") #polys is SpatialPolygonsDataFrame (or Points)

df <- as.data.frame(spdf) #convert SpatialPointsDataFrame spdf to a dataframe

#---- Create Spatial objects ----

# Create a SpatialPoints object from a matrix. Not sure how to set the column names
coords<-matrix(c(-45.1692940000,-23.4697250000),nrow=1)
pts<-SpatialPoints(m, proj4string=CRS('+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs'))

# Create a SpatialPointsDataFrame object from data.frame dat1 (with cols 'lon' and 'lat')
# Note need to remove lon/lat columns from data argument
dat1 <- as.data.frame(dat1)
spdf <- SpatialPointsDataFrame(
  coords=dat1[,c('lon','lat')], 
  data=dat1[,!names(dat1) %in% c('lon','lat')]),
  proj4string=CRS("+proj=longlat +datum=WGS84"))

# Promote a data frame to an SP or SPDF object.
# Note here the @data argument does not have lon/lat columns
spdf1 <- dat1
coordinates(spdf1)=~lon+lat #set lon, lat as the coordinates
proj4string(spdf1) <- '+proj=longlat +datum=WGS84'

crs(spdf1) <- CRS('+proj=longlat +datum=WGS84') #also can use CRS, but this requires raster package

#make the grid from the centers of raster cells
grid <- SpatialPoints(
  coords=data.frame(xyFromCell(rast, 1:ncell(rast))),
  proj4string=crs(rast))

#---- Spatial*DataFrame ----
na.omit(spdf) #remove rows with NA (not sure if this works)
which(is.na(spdf['mycol']@data)) #shows which rows contain NA

#---- SpatialPointsDataFrame ----
spdf[,'mycol'] #this will return an spdf with just the column 'mycol'
spdf$mycol #returns a vector
spdf@data$mycol #also returns a vectors (seems same as spdf$)
spdf[['mycol']]] #also returns a vector
crs(spdf) #see the projection
mydata@proj4string #see the projection (same as crs())
coordinates(spdf) #see the coordinates

zerodist(df) #find point pairs with equal spatial coordinates

#https://gis.stackexchange.com/questions/63577/joining-polygons-in-r
spainportu <- subset(world,world$NAME=='Spain' | world$NAME=='Portugal')
spainportu$ID <- 1
dissolved <- unionSpatialPolygons(spainportu,spainportu$ID) #in maptools library

ptsClip <- pts[poly,] #spatial subset pts by poly (return all points that are within poly

#---- SpatialPolygons ----#
# SpatialPolygons are complex. 
# a SpatialPolygons contains 1..* Polygons objects. So, takes a list of Polygons objects.
# a Polygons object contains 1..* Polygon objects. So, takes a list of Polygon objects.
p1 = Polygon(cbind(c(2,4,4,1,2),c(2,3,5,4,2))) #create Polygon objects
p2 = Polygon(cbind(c(5,4,2,5),c(2,3,2,2)))
ps1 = Polygons(list(Sr1,Sr2), "ps1") #create the Polygons object
spoly = SpatialPolygons(list(ps1)) #create the SpatialPolygons object

spoly@polygons[[1]] #this is the first Polygons object
spoly@polygons[[1]]@Polygons[[1]] #example, this is the first Polygon object

#---- transforming points ----#

#seems there are no errors when translating points between WGS84<->UTM or UTM<->UTM
pt <- SpatialPoints(
  coords=data.frame(lon=10.9736,lat=52.4577), 
proj4string=CRS("+proj=longlat +datum=WGS84"))
coordinates(pt)

ptUtm32 <- spTransform(pt,CRS('+proj=utm +zone=32 +ellps=WGS84 +units=m +no_defs'))
coordinates(ptUtm32)

ptwgs <- spTransform(ptUtm32,CRS("+proj=longlat +datum=WGS84"))
coordinates(ptwgs)

ptUtm33 <- spTransform(ptwgs,CRS('+proj=utm +zone=33 +ellps=WGS84 +units=m +no_defs'))
coordinates(ptUtm33)

ptUtm32_2 <- spTransform(ptUtm33,CRS('+proj=utm +zone=32 +ellps=WGS84 +units=m +no_defs'))
coordinates(ptUtm32_2)

#---- spatial operations ----#

utm <- readOGR(dsn="/Users/benc/projects/gis-data/UTM_zones/UTM_Zone_Boundaries", layer="UTM_Zone_Boundaries")

plot(crop(utm,extent(mv)))
points(mv)

#---- save bounding box of points ----#

#have to convert extent to SpatialPolygons, then convert this to SpatialPolygonsDataFrame
poly <- as(extent(spdf),'SpatialPolygons')
poly <- as(poly,'SpatialPolygonsDataFrame')
crs(poly) <- CRS('+proj=utm +zone=32 +ellps=WGS84 +units=m +no_defs')
writeOGR(obj=poly, dsn=file.path('results/stpp_models',datName,'data/pts_bbox'), 
         layer="pts_bbox", driver="ESRI Shapefile")

### projections ###

rgdal::make_epsg() #this is a list of all ESPG codes and associated CRS

CRS() #this is from sp package
crs() #this is from raster package

CRS("+proj=longlat") #WGS84
CRS("+proj=longlat +ellps=WGS84") #WGS84
CRS("+proj=longlat +datum=WGS84") #WGS84
CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0") #WGS84
CRS('+proj=aea +lat_1=43 +lat_2=62 +lat_0=30 +lon_0=10 +x_0=0 +y_0=0 +ellps=intl +units=m +no_defs') #albers
CRS('+proj=utm +zone=33 +ellps=WGS84 +units=m +no_defs') #UTM zone 33N
CRS('+proj=utm +zone=33 +south +ellps=WGS84 +datum=WGS84 +units=m +no_defs') #UTM zone 33S (note +south)

#proj4 notes
#+towgs84=0,0,0 the last portion of each proj4 string is +towgs84=0,0,0 . This is a conversion factor that is used if a datum conversion is required.
# this is from (http://bit.ly/2utPyH7) and I don't know what it's supposed to mean.
