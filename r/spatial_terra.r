
#---- Creating rasters ----

rast(nrow=100,ncol=100) #This assumes a wgs84 grid, e.g -180, 180, -90, 90. Sets resolution based on nrow/ncol

rast(nrow=100,ncol=100,xmin=0,xmax=100,ymin=0,ymax=100) #Specify xmin etc to control the grid.

rast(matrix(1:4,nrow=2,ncol=2)) #make a raster from a matrix

## Raster Info

cat(crs(r1)) #Print crs in WKT format
crs(r1,proj=TRUE) #Print crs in proj format
crs(r1,describe=TRUE) #Prints a table that includes ESPG code (if available)

describe('path/to/rast.tif') #GDALinfo. #Sometimes does not print in RStudio but prints when running the report

#INT/FLT integer/float; 1-4 num bytes; S/U signed/unsigned.
#See: ?writeRaster
datatype(r) 

res(rLulc) #Print x,y resolution

gdal() #See the gdal version

#Assign labels to an categorical raster

#!!! Note **MUST** be dataframe. It will give a strange error 
classes <- data.frame(id=0:6,
  cover=c('NoData','Cropland','Forest','Grassland','Urban','Barren','Water'))

levels(rLulc) <- classes

#----
#---- Manually changing raster values ----
#----

tpl <- rast(nrow=100,ncol=100,xmin=0,xmax=100,ymin=0,ymax=100)

#updating according to a matrix. (0, 0) is the top left corner
# rows is y. 0 starts at the top
# columns is x. 0 starts on the left
env <- tpl; env[60:80,40:50] <- 1; plot(env) #The y-scale is confusing because it should start from the top
env <- tpl; env[40:50,60:80] <- 1; plot(env) #The y-scale is confusing because it should start from the top


