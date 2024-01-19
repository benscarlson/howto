
## Raster Info

cat(crs(r1)) #Print crs in WKT format
crs(r1,proj=TRUE) #Print crs in proj format

describe('path/to/rast.tif') #GDALinfo
