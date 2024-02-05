
## Raster Info

cat(crs(r1)) #Print crs in WKT format
crs(r1,proj=TRUE) #Print crs in proj format

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
