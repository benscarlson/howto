
## Raster Info

cat(crs(r1)) #Print crs in WKT format
crs(r1,proj=TRUE) #Print crs in proj format

describe('path/to/rast.tif') #GDALinfo

datatype(r)

res(rLulc) #Print x,y resolution

#Assign labels to an categorical raster

#!!! Note **MUST** be dataframe. It will give a strange error 
classes <- data.frame(id=0:6,
  cover=c('NoData','Cropland','Forest','Grassland','Urban','Barren','Water'))

levels(rLulc) <- classes
