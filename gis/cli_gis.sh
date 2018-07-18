#https://github.com/dwtkns/gdal-cheat-sheet
#http://joeyklee.github.io/broc-cli-geo/guide/index.html
#http://opengeoportal.org/software/resources/gdal-and-open-source-geoprocessing-tutorials/
#http://www.gdal.org/gdal_utilities.html
##https://www.manning.com/books/geoprocessing-with-python
#https://pcjericks.github.io/py-gdalogr-cookbook/
#https://www.springer.com/us/book/9783319018232 (Book: Open Source Geospatial Tools)
#http://pktools.nongnu.org/html/index.html (pktools)

#-----------------
#---- RASTERS ----
#-----------------

#---- metadata ----

#gdalinfo
gdalinfo -stats file.tif #see the min and max pixels of a tiff file
#origin: this is the upper left corner of the upperleft pixel, in coordinate system defined by the crs of the raster
# note this matches the "Upper Left" entry of the "Corner Coordinates" section

gdalsrsinfo file.tif #see the CRS of the image
listgeo -proj4 waterdistance.tif #another way to see metadata
gdal_edit.py -a_srs EPSG:4326 myfile.tif #define projection when it is not set
gdal_edit.py -a_nodata 255 pct_tree_30m.tif #set nodata value

#---- transform rasters ----

#mosiac rasters
gdal_merge.py -pct -n 0 -a_nodata 0 -co COMPRESS=DEFLATE -o out.tif in1.tif in2.tif
-pct #this takes the color table from the first input and applies to to output
-n 0 #this tells merge to ignore these values from input rasters (i.e. treat as no data)
-a_nodata #this tells merge to set 0 as the no data value in the output
-co #Seems COMPRESS=LZW is also common. This writes the raster as a compressed file. Compressed might be 400MB, uncompressed 6GB!
#Note on COMPRESS: LZW has same compressin ration as DEFLATE, but works on more software (like ArcGIS 9.x).

#convert to wgs84
gdalwarp -t_srs '+proj=longlat +datum=WGS84 +no_defs' image.tif image_wgs84.tif
#convert to UTM 33N, and resample using cubic method
gdalwarp -t_srs '+proj=utm +zone=33 +ellps=WGS84 +units=m +no_defs' -r cubic image.tif image_utm33N.tif
#other parameters
-dstnodata 0 #set 0 to nodata value. if nodata is set on input image, it will also be set on output
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
