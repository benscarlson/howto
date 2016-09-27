gdalinfo -stats file.tif #see the min and max pixels of a tiff file

#convert a shapefile to a raster. 
# -burn 1: puts a '1' in each cell. 
# -l range: the layer is names 'range'
# -tr grid size, based on crs (this is 30 seconds based on espg 4326
gdal_rasterize -burn 1 -l range -tr 0.00833333 0.00833333 range.shp range.tif

listgeo -proj4 waterdistance.tif #another way to see metadata
