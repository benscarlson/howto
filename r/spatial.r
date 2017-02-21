http://www.maths.lancs.ac.uk/~rowlings/Teaching/UseR2012/cheatsheet.html

as.data.frame(spdf) #convert SpatialPointsDataFrame spdf to a dataframe

#raster package
nlayers(mystack) #number of RasterLayers in the RasterStack
names(mystack) #the names of the RasterLayers in the RasterStack
extent(mystack) #extent of the RasterLayers in the RasterStack
mystack[[1]] #extract the first RasterLayer from the RasterStack
names(layer) <- 'layername' #set the name of RasterLayer to 'layername'
ncell(layer) #number of cells
calc(layer,function(x) f(x)) #apply function f to layer
cellStats(layer,sum) #returns the sum of all cells in layer. can also use mean, min, etc.
metadata(layer) <- metadata #adds metadata to layer
rdist_r@data@min;rdist_r@data@max #see min and max values for a rasterLayer
writeRaster(env,'misc/tinamus_env.tif','GTiff') #write a raster to tif
env_tif <- raster('misc/tinamus_env.tif') #load the raster from tif
raster::extract(env_rdata,pts,df=T,ID=F) #extract raster values given a set of points (here, a SpatialPoints object)
     
getGDALVersionInfo()

shapefile('myshapefile.shp') #part of raster package. load shapefile into a SpatialPolygonsDataFrame

#create a SpatialPoints object. Not sure how to set the column names
coords<-matrix(c(-45.1692940000,-23.4697250000),nrow=1)
pts<-SpatialPoints(m, proj4string=CRS('+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs'))
coordinates(df)=~Longitude+Latitude #turn df into a SpatialPointsDataFrame. set Longitude and Latitude as coordinates
proj4string(tracks) <- CRS('+proj=longlat +datum=WGS84') #set the crs of the spatialpointsdataframe
mydata@proj4string #see the projection

zerodist(df) #find point pairs with equal spatial coordinates
     
#raster    

     
bbox(obj) #get the bounding box of spatial object obj

### plotting polygons ###
splancs::polymap(mymatrix) #plot a polygon for a [,2] matrix
