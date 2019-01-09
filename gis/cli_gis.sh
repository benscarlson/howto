#https://github.com/dwtkns/gdal-cheat-sheet <- lots of great examples
#http://joeyklee.github.io/broc-cli-geo/guide/index.html
#http://opengeoportal.org/software/resources/gdal-and-open-source-geoprocessing-tutorials/
#http://www.gdal.org/gdal_utilities.html
##https://www.manning.com/books/geoprocessing-with-python
#https://pcjericks.github.io/py-gdalogr-cookbook/
#https://www.springer.com/us/book/9783319018232 (Book: Open Source Geospatial Tools)
#http://pktools.nongnu.org/html/index.html (pktools)

#GDAL/ OGR cheatsheet: https://geospatialwandering.wordpress.com/2017/01/25/gdal-ogr-cheatsheet/

#-----------------
#---- RASTERS ----
#-----------------

#---- metadata ----

#---- display metadata ----

#-- statistics
gdalinfo -stats file.tif #displays stats if they exist in the raster or in an .aux.xml file
# if aux file is present, it will *not* recompute statistics if something has changed
gdalinfo -mm file.tif #will recompute min/max, but not store statistics. Seems that if a .aux.xml file is present, does not recompute

#origin: this is the upper left corner of the upperleft pixel, in coordinate system defined by the crs of the raster
# note this matches the "Upper Left" entry of the "Corner Coordinates" section


gdalsrsinfo file.tif #see the CRS of the image
listgeo -proj4 waterdistance.tif #another way to see metadata

#---- edit metadata ----
gdal_edit.py -a_srs EPSG:4326 myfile.tif #define projection when it is not set
gdal_edit.py -a_nodata 255 pct_tree_30m.tif #set nodata value

#---- transform rasters ----

#-- mosiac rasters
gdal_merge.py -pct -n 0 -a_nodata 0 -co COMPRESS=DEFLATE -o out.tif in1.tif in2.tif
-pct #this takes the color table from the first input and applies to to output
-n 0 #this tells merge to ignore these values from input rasters (i.e. treat as no data)
-a_nodata #this tells merge to set 0 as the no data value in the output
-co #Seems COMPRESS=LZW is also common. This writes the raster as a compressed file. Compressed might be 400MB, uncompressed 6GB!
#Note on COMPRESS: LZW has same compressin ration as DEFLATE, but works on more software (like ArcGIS 9.x).

#-- convert to different projection/coordinate system
gdalwarp -t_srs '+proj=longlat +datum=WGS84 +no_defs' -co COMPRESS=LZW image.tif image_wgs84.tif

#convert to UTM 33N, and resample using cubic method
gdalwarp -t_srs '+proj=utm +zone=33 +ellps=WGS84 +units=m +no_defs' -r cubic image.tif image_utm33N.tif
#other parameters
-dstnodata 0 #set 0 to nodata value. if nodata is set on input image, it will also be set on output
-r near #use nearest neighbor resampling (I think this is the default)
-t_src EPSG:3035 #can also use EPSG code to specify projection
-co COMPRESS=LZW #LZW compression. 

#-- aligning grids
# to make sure images have the same target grid, use tap
# note this isn't the same as making one image align to an existing, target image
# https://blogg.uit.no/thk031/2013/05/04/re-projecting-images-to-the-same-grid-using-gdal/
gdalwarp -tr 30 30 -tap -t_srs EPSG:32633 -co COMPRESS=LZW image_utm32.tif image_utm33.tif
-tr #the pixel size

#---- create rasters ----

#-- convert a shapefile to a raster. 
# -burn 1: puts a '1' in each cell. 
# -l range: the layer is names 'range'
# -tr grid size, based on crs (this is 30 seconds based on espg 4326
gdal_rasterize -burn 1 -l range -tr 0.00833333 0.00833333 range.shp range.tif

#---- clip rasters ----
#shows how to clip with either bounding box coords or shapefile
#http://joeyklee.github.io/broc-cli-geo/guide/XX_raster_cropping_and_clipping.html

#-te x_min y_min x_max y_max
#input.tif: the input file to be clipped
#clipped_output.tif: the clipped output file

gdalwarp -te 7.8140 46.7855 10.5111 48.5825 -co COMPRESS=DEFLATE guf04_koz.tif guf04_koz100km.tif

#---- VECTOR ----

#metadata about a shapefile
ogrinfo -ro -so -al myfile.shp #list important metadata
#-al lists info on all layers, layer is not specified. to specify layer, use myfile.shp mylayer
#-so: Summary Only: supress listing of features, show only the summary information like projection, schema, feature count and extents.

ogr2ogr -f GeoJSON myfile.geojson myfile.shp #convert shp to geojson


#---- Configuration ----

#my command line is using GDAL 1.11.2, released 2015/02/10
which gdalinfo #/usr/local/bin/gdalinfo
ls -al /usr/local/bin/gdalinfo #/usr/local/bin/gdalinfo -> ../Cellar/gdal/1.11.2_1/bin/gdalinfo

#I also have a version of GDAL in /Library/Frameworks/GDAL.framework/Programs
#I think this is the version from KyngKaos.
./gdalinfo -version #GDAL 1.11.3, released 2015/09/16

#When I load library(sf) in R, it seems I link to version 2.1.3!
library(sf) #Linking to GEOS 3.6.1, GDAL 2.1.3, proj.4 4.9.3

#---- pktools ----#
Pktools. https://link.springer.com/chapter/10.1007%2F978-3-319-01824-9_12

