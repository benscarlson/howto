#https://github.com/dwtkns/gdal-cheat-sheet
#http://joeyklee.github.io/broc-cli-geo/guide/index.html

#-----------------
#---- RASTERS ----
#-----------------

#---- metadata ----
gdalinfo -stats file.tif #see the min and max pixels of a tiff file
gdalsrsinfo file.tif #see the CRS of the image
listgeo -proj4 waterdistance.tif #another way to see metadata
gdal_edit.py -a_srs EPSG:4326 myfile.tif #define projection when it is not set

#---- transform rasters ----

#mosiac rasters
gdal_merge.py -o out.tif tile1.tif tile2.tif tile3.tif

#convert to wgs84
gdalwarp -t_srs '+proj=longlat +datum=WGS84 +no_defs' image.tif image_wgs84.tif
#convert to UTM 33N, and resample using cubic method
gdalwarp -t_srs '+proj=utm +zone=33 +ellps=WGS84 +units=m +no_defs' -r cubic image.tif image_utm33N.tif
#other parameters
-dstnodata 0 #set 0 to nodata value
-r near #use nearest neighbor resampling (I think this is the default)
-t_src EPSG:3035 #can also use EPSG code to specify projection

#---- create rasters ----

#-- convert a shapefile to a raster. 
# -burn 1: puts a '1' in each cell. 
# -l range: the layer is names 'range'
# -tr grid size, based on crs (this is 30 seconds based on espg 4326
gdal_rasterize -burn 1 -l range -tr 0.00833333 0.00833333 range.shp range.tif

#---- VECTOR ----

#metadata about a shapefile
ogrinfo -ro -so -al myfile.shp #list important metadata
#-al lists info on all layers, layer is not specified. to specify layer, use myfile.shp mylayer
#-so: Summary Only: supress listing of features, show only the summary information like projection, schema, feature count and extents.

ogr2ogr -f GeoJSON myfile.geojson myfile.shp #convert shp to geojson
