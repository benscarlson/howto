//---------------//
//---- links ----//
//---------------//

//Data request? https://code.google.com/a/google.com/p/ee-testers-external/issues/list
//Tools to use in playground. Cloud masking, others. https://github.com/fitoprincipe/geetools-code-editor
//Tool to auto click "Run". https://github.com/kongdd/GEE_Tools/blob/master/gee_monkey.js
//Tools for uploading to GEE: https://github.com/samapriya/geeup
//Tensor flow examples: https://developers.google.com/earth-engine/tf_examples
//List of all data products (updated daily): https://console.cloud.google.com/storage/browser/earthengine-stac/1.0.0/catalog
//List of all data prodcuts (updated weekly and includes a bunch of other features). https://github.com/samapriya/Earth-Engine-Datasets-List
//Another list of all data products (maybe json format): https://gee.stac.cloud/?t=catalogs
//Batch submit tasks: https://github.com/MarcYin/GeeBatch (Seems to build on tampermonky script) - Not sure if this works anymore. See Tasks section.
//Collection of tools for working with GEE: https://github.com/gee-community

//--------------------------------//
//---- Tutorials and training ----//
//--------------------------------//

//Online book: Cloud-based remote sensing with GEE. https://www.eefabook.org/go-to-the-book.html
//Community tutorials. https://developers.google.com/earth-engine/tutorials
//  *  Has L7 & L8 harmonization example!! 

//F4 - Earth Engine Fundamentals and Applications - EEFA - Live Document
//https://docs.google.com/document/d/11oo1TuvXyEvReoYLDeTcoh16rEN90I8Bf5qp0KxVu7U/edit#heading=h.7fxubhb0q8tn
//Chapter F4.2: Aggregating Images for Time Series

//---- shortcut keys ---//
cmd + /  for //

cmd + shift + / for /**/

// ---- code management ----//

//haven't tried this, but should be how to clone my repo to local
git clone https://earthengine.googlesource.com/users/benscarlson/default

//---- metadata ----//
//Number of images in landsat collections: https://code.earthengine.google.com/257808f57d8feedeaf18a7d50d738ed2
// subject: "GEE's data catalogue"
//Total size of collection as of Apr 2020: 30P

//---- Assets ----//

//View asset information
//https://code.earthengine.google.com/?asset=COPERNICUS/CORINE/V20/100m 

//---- External libraries ----//

//Landtrendr API. Has library for building consistent surface reflectance across landsats
//Also will do cloud masking. See link below for lots more discussion on merging landsat data
//https://groups.google.com/d/msg/google-earth-engine-developers/15gsO2twNYU/vGgU1YheGgAJ
//https://emapr.github.io/LT-GEE/api.html

//---- Objects ----//
object.name() //get the type of object

//---- Lists ----//

//---- iterate and return a single value --

// This makes a list [1,2,3,4,5]
// and returns a single value, the sum of all items in the list (15)

var lst = ee.List.sequence(1,5,1);
print(lst);

var runsum = lst.iterate(function(item,sum) {
  item = ee.Number(item);
  sum = ee.Number(sum);

  return(sum.add(item));
},0);

print(runsum);

//--- iterate and accumulate in a list
//  kind of like cumsum in R
var lst = ee.List([1,2,3]);
var first = ee.List([0]);

var accumulate = function(val,list){
  //we are building up 'list' that is started with 'first'
  //so, get(-1) always gets the last item in the list that we are building up
  var prev = ee.Number(ee.List(list).get(-1));
  var added = ee.Number(val).add(prev);
  return ee.List(list).add(added);
};

var mysums = lst.iterate(accumulate,first);

print(mysums);


//--------------------//
//---- geometries ----//
//--------------------//

//xMin, yMin, xMax, yMax
var rect = ee.Geometry.Rectangle([11.87669, 51.92500, 12.48346, 52.25738]);
Map.addLayer(rect);

//get geometries from each image and merge them
var geoms = imgLst.map(function(img) {
    return ee.Image(img).geometry();
});

var geom = ee.Geometry.MultiPolygon(geoms).dissolve();

//create a ring and sample from it
//https://code.earthengine.google.com/a619ac5d9df6a9ca95be3a3ebe9c987c (http://bit.ly/2MknooI)

//-------------------------//
//---- features ----//
//-------------------------//

var f = ee.Feature(
    ee.Geometry.Point([10.9736,52.4577]));

//get a bounding box
var pts_fc = ee.FeatureCollection(occTable);
var bbox = pts_fc.geometry().bounds();

f.toDictionary(); //Get dictionary of properties
f.propertyNames(); //Get the names including system properties (e.g. system:index)

//----
//---- ee.FeatureCollection ----//
//----

//Create an fc
var fc = ee.FeatureCollection( //can also construct with single geometry, or list of geometries, list of features
  ee.Feature(
    ee.Geometry.Point([12.0756,52.1151])));

var bbox = fc.geometry().bounds(); //This gets the bbox of an fc. Fails at large number of pts.

//----
//---- ee.ImageCollection ----//
//----

ee.ImageCollection.fromImages(imgLst) //Create an image collection from a list of images

//to pull images from an imagecollection by index, convert to a list
var lst = ic.toList(5); //5 is max number of images to fetch from the collection
print(lst);
print(ee.Image(lst.get(0))); //get the frist image in the list

col.toBands(); //Convert image collection to multi-band image

ic.get('system:id') //Get the asset name. Note this is system:id and not system:index

//--------------//
//---- misc ----//
//--------------//

reduceRegion(ee.Reducer.frequencyHistogram()) //compute number of distinct values in a histogram
reduceRegion(ee.Reducer.sum().grouped(1)) //use raster zonal area (zonal stats) to realize sum, max value calculation

var fc = (ee.FeatureCollection('ft:1Ec8IWsP8asxN-ywSqgXWMuBaxI6pPaeh6hC64lA')
      .filter(ee.Filter().eq('ECO_NAME', 'Sonoran desert')));

//add lon, lat bands to img      
img = img.addBands(ee.Image.pixelLonLat());

//paint a feature collection onto an image, color by the attribute "ID" (note: not tested)
https://groups.google.com/d/msg/google-earth-engine-developers/_OBrauG-mQU/_tZL09nWbfwJ
var img = ee.Image().toByte().paint(fc, "ID");

var img = ee.Image().toByte().paint(fc, 1); //paint a 1 into the pixels. Unpainted pixels will be masked.

//Look at this code for how to export a histogram
//https://code.earthengine.google.com/259b086d689ff91d28afbed5041f61f7

//---- generate grids ----//
//https://code.earthengine.google.com/140d61ef71730ea7ce38c85f5705497e
//https://code.earthengine.google.com/3b4d15f4dc0eace8c5cdd5809feb5f06
//https://gis.stackexchange.com/questions/231959/draw-a-grid-of-polygons-in-google-earth-engine/328662

//----
//---- Masking
//---- 

//Those with a mask value of 0 or below will be transparent. Those with a mask of any value above 0 will be rendered.

.updateMask() //only masks out currenly unmasked pixels
.selfMask() //try this out
.unmask() // turns any currently masked pixels into a value, 0 by default. can pass a value in
var msk = img.select([0]).gt(0); //create a mask

//Exporting NAs: try casting to float, then exported tif may have NA values.

//----
//---- date/time ----
//----

//both of these formats can be parsed natively by ee
print(ee.Date('2014-06-02'));
print(ee.Date('2014-06-02T05:50:06Z'));
print(img.get('system:time_start_str')).format('yyyy-MM-dd HH:mm:ss') //print a date object as a string

mydate.getRelative('day','year'); //get doy
mydate.advance(1,'month').advance(-1,'second')//get end date for a monthly timeseries, given a start date

//extract start date and remove time component (is there a better way?)
var dte = ee.Date(img.get('system:time_start'));
dte = ee.Date(dte.format('yyyy-MM-dd'));

//GEE system properties for start, end dates (in milliseconds)
system:time_start
system:time_end

//-------------------//
//---- filtering ----//
//-------------------//

//filter an image collection to extract one image
var img = ee.ImageCollection("LANDSAT/LC8_L1T_8DAY_NDVI")
  .filterMetadata('system:index','equals','20130626') //Note filter metaMetadata is deprecated

.filter(ee.Filter.eq('system:index','20130626'))

//filter an image collection using metadata field by list
var col = ee.ImageCollection('MODIS/MOD11A2');
var images = ['MOD11A2_005_2014_12_27','MOD11A2_005_2014_12_27'];

//filters have params in the following order:
// (leftField, rightValue, rightField, leftValue)
// below are equivilant
var filt = ee.Filter.inList({leftField:'system:index',rightValue:images, rightField:null, leftValue:null});
var filt = ee.Filter.inList('system:index',images);

ic.filter(ee.Filter.listContains("system:band_names", "N")) //filter by band name. band names are not in metadata but can filter by this property
//https://code.earthengine.google.com/8a983033d4fff873f5a647e6cfab857f

//filter based on a supplied list
var filt = col.filter(
    ee.Filter.inList('path',ee.List([194,195])));

Map.addLayer(img.select([0]).mask(msk),{palette:palette});

var obj = ee.ImageCollection("LANDSAT/LC08/C01/T1_SR") 
  .filterDate('2013-06-26', '2013-07-04')

//filter an image collection with timestamps by date
//note this will take all timestamps less than 2018-09-01, so it will return
//add timestamps on Aug 81, but none on Sep 1
var fltrTs = ee.Filter.and(
  ee.Filter.greaterThanOrEquals('timestamp', '2018-08-01'),
  ee.Filter.lessThan('timestamp', '2018-09-01')
);

pts = pts.filter(fltrTs);

//-----------------------//
//---- spatial joins ----//
//-----------------------//

// Define a spatial filter as geometries that intersect.
var spatialFilter = ee.Filter.intersects({
  leftField: '.geo',
  rightField: '.geo',
  maxError: 10
});

// Define a save all join.
//matchesKey is just the name of the property that holds the images
var saveAllJoin = ee.Join.saveAll({
  matchesKey: 'tiles',
});

// Apply the join.
var joined = saveAllJoin.apply(primaryCollection, secondaryCollection, spatialFilter);

var gisaFL = ee.ImageCollection.fromImages(joined.first().get('tiles')); //this assumes 

//--------------------//
//----- reducers -----//
//--------------------//

//-- to get crs and crsTransform, do getInfo on the projection object
var proj = col.first().projection().getInfo();

print(proj.crs);
print(proj.transform);

//-- reduceRegions
var img2 = img1.reduceRegions(bbox,ee.Reducer.mean()); //simplest call to reduceRegions, will require crs,etc. in some situations.

var img2 = img1
  .reduceRegions({
    collection:bbox,
    reducer:ee.Reducer.mean(),
    crs: proj.crs,
    crsTransform:proj.transform });

//tileScale
//Some functions have this parameter. This changes the size of each tile that is computed and can reduce memory. 
// Larger scale means smaller tile, less memory, more computations
// not related to "scale" parameter
//https://groups.google.com/g/google-earth-engine-developers/c/MiktRhbqhZ4

//---- Sample regions ----//

//Extract pixel values given polygon
//https://gis.stackexchange.com/questions/407840/extracting-pixel-values-in-sample-polygons-in-google-earth-engine
img.sampleRegions({collection:poly,scale:30})

//Extract based on random number of samples in the region
var pts = ee.FeatureCollection.randomPoints({
  region: poly,
  points: 1000
});

var samp = img.sampleRegions({collection:pts,scale:30})


//---- Frequency histogram ----//

//code to export histogram from Noel
//https://code.earthengine.google.com/8fb0aa4de96c653c98728e1fb6293c60

//Discusion of how to represent equal area. Use pixelArea?
//https://groups.google.com/g/google-earth-engine-developers/c/LTo94esE8cs/m/QDljOTK8BAAJ

//----
//---- Geoprocessing ----//
//----

img.remap([1,2],[1,1],0); //maps pixels with 1, 2 to 1, and everything else to 0

//Distance to pixels calculation
//Fast distance transform is in units of pixels^2, which is strange
//Take sqrt to make units pixels
//Then multiply by pixelArea().sqrt() to get distance in meters
//neighborhood is max distance (in pixels). this is supposed to limit how far to search from any given pixel
// but doesn't seem to work like I expect. 
var region = tree.geometry().bounds();

var dist = urban
  .fastDistanceTransform(1000).sqrt()
  .clip(region)
  .multiply(ee.Image.pixelArea().sqrt());


fc.union() //Union/merge all features in a feature collection

//--- Random points and integers ---//

//See script: https://code.earthengine.google.com/?scriptPath=users%2Fbenscarlson%2Fdefault%3Asnippets_and_examples%2Frandom_points_and_integers

//-----------------//
//---- Modules ----//
//-----------------//

//users/benscarlson/modules:module.js
exports.myfun = function(x) {return x};

var mod = require('users/benscarlson/modules:module.js');
var mod = require('users/benscarlson/modules:ms2/ndvi/module.js'); //Note module can be nested w/in folders


//--------------------//
//---- Visualize -----//
//--------------------//

//Example color ramp for points
//https://code.earthengine.google.com/4bf428a84cc19169a3e39914fc8de4a8

//https://code.earthengine.google.com/?accept_repo=users/gena/packages&scriptPath=users/gena/packages:style-test-symbology

Map.addLayer(pts,{color: 'BA1E01'}) //color points reddish color

//color points by month
var colors = ee.List (["ff5050","ff7d52","ffa852","ffd452","ffff52","d4ff52","a8ff52","7dff52","52ff52"])
var result = pb_20982_2008.map(function(f){
  var colorIndex = ee.Number(f.get('month')).min(8)
  return f.set('style', {color:colors.get(colorIndex)})
})
//also check out:
//https://code.earthengine.google.com/4bf428a84cc19169a3e39914fc8de4a8
//https://developers.google.com/earth-engine/feature_collections_visualizing

//---- palettes ----//

//Seems it requires a list of color strings. Use below to reverse order
.split(',').reverse().join();

//-- apply palettes
Map.addLayer(img.select('NDVI'), {palette:palette});
Map.addLayer{fc, palette:'blue'} //should make all polygons blue

//bright/aqua greenish to yellowish to red-orangeish
var palette = ['b5acff','8dcfff','7ffff9','71ff96','c0ff6d','eeff64','ffc952','ffaf38','ff471d'];
//EVI palette
var palette = 'FFFFFF,CE7E45,DF923D,F1B555,FCD163,99B718,74A901,66A000,529400,3E8601,207401,056201,004C00,023B01,012E01,011D01,011301';
var palette = ['b5acff','8dcfff','7ffff9','71ff96','c0ff6d','eeff64','ffc952','ffaf38','ff471d'];

//--- vegetation palettes ----//
var palette = 'FFFFFF,CE7E45,DF923D,F1B555,FCD163,99B718,74A901,66A000,529400,3E8601,207401,056201,004C00,023B01,012E01,011D01,011301';
//this comes from R: paste(rev(terrain.colors(100)),collapse=',')
var vegPal = "#F2F2F2FF,#F2EDEDFF,#F2E8E8FF,#F1E4E3FF,#F1DFDEFF,#F1DBD9FF,#F1D7D4FF,#F0D4CFFF,#F0D0CAFF,#F0CDC5FF,#F0C9C0FF,#EFC6BBFF,#EFC4B6FF,#EFC1B1FF,#EFBFACFF,#EEBCA7FF,#EEBAA2FF,#EEB99DFF,#EEB798FF,#EDB593FF,#EDB48EFF,#EDB389FF,#EDB285FF,#ECB280FF,#ECB17BFF,#ECB176FF,#ECB171FF,#EBB16CFF,#EBB167FF,#EBB263FF,#EBB25EFF,#EAB359FF,#EAB454FF,#EAB550FF,#EAB74BFF,#E9B846FF,#E9BA41FF,#E9BC3DFF,#E9BE38FF,#E8C033FF,#E8C32EFF,#E8C62AFF,#E8C825FF,#E7CB20FF,#E7CF1CFF,#E7D217FF,#E7D612FF,#E6D90EFF,#E6DD09FF,#E6E105FF,#E6E600FF,#E0E400FF,#DAE300FF,#D4E200FF,#CEE000FF,#C8DF00FF,#C3DE00FF,#BDDC00FF,#B7DB00FF,#B2DA00FF,#ACD800FF,#A7D700FF,#A2D600FF,#9CD500FF,#97D300FF,#92D200FF,#8DD100FF,#87CF00FF,#82CE00FF,#7DCD00FF,#78CB00FF,#74CA00FF,#6FC900FF,#6AC800FF,#65C600FF,#60C500FF,#5CC400FF,#57C200FF,#53C100FF,#4EC000FF,#4ABE00FF,#45BD00FF,#41BC00FF,#3DBB00FF,#39B900FF,#35B800FF,#30B700FF,#2CB500FF,#28B400FF,#24B300FF,#21B100FF,#1DB000FF,#19AF00FF,#15AE00FF,#12AC00FF,#0EAB00FF,#0AAA00FF,#07A800FF,#03A700FF,#00A600FF";
//this is one that Mao-Ning used for MODIS EVI. Might be same as above.
var palette = ['FFFFFF', 'CE7E45', 'DF923D', 'F1B555', 'FCD163', '99B718',
               '74A901', '66A000', '529400', '3E8601', '207401', '056201',
               '004C00', '023B01', '012E01', '011D01', '011301'];

// palette for USGS/NLCD
// https://code.earthengine.google.com/364a21cf48da7160d1f96769e367a58d

//Viridis (20)
var pal = '440154FF,481568FF,482677FF,453781FF,3F4788FF,39558CFF,32648EFF,2D718EFF,287D8EFF,238A8DFF,1F968BFF,20A386FF,29AF7FFF,3CBC75FF,56C667FF,74D055FF,94D840FF,B8DE29FF,DCE318FF,FDE725FF';

//paint a set of polygons polyFC (with identification 'id') to image and visualize
//example: https://code.earthengine.google.com/849862c672e8e5028a4d86ee14cf8c36
Map.addLayer(ee.Image().int().paint(polyFC,'id').randomVisualizer())

//--- Landsat 7 ---//
var viz = {bands: ['B3', 'B2', 'B1'], min: 0, max: 3000, gamma: 1.4};

//--- Landsat 8 ---//
var viz = {bands: ['B4', 'B3', 'B2'], min: 0, max: 3000,gamma: 1.4};

//---- map legends ----//

//https://gis.stackexchange.com/questions/290713/adding-map-key-to-map-or-console-in-google-earth-engine
//https://mygeoblog.com/2016/12/09/add-a-legend-to-to-your-gee-map/

//-----------------------//
//---- Scale and CRS ----//
//-----------------------//

//See Noel's response and example setting crs instead of scale parameter
//https://groups.google.com/g/google-earth-engine-developers/c/LTo94esE8cs/m/QDljOTK8BAAJ
var proj = ee.Projection("EPSG:4326").atScale(1)

//---- crs/crsTranform ----//

//From Genna: If you need to preview how results will look like at specufic scale - resproject you image before 
// adding to map, image.reproject(ee.Projection('EPSG:3857').atScale(100)), this may break computation if you zoom out 
// too much. 
//From Matt: more example code for how to set the scale on the playground viewer
var proj = ee.Projection('EPSG:4326').atScale(20);
Map.addLayer(ImgCnnLMed.reproject(proj).selfMask(),{palette:'00ff00'},'ImgCnnLMed');
//See here for detailed explaination from Matt Hancher for how to set crs/crsTransform
//Subject: 'Assets and CRSs, how to use them properly in GEE?'
//https://goo.gl/y76A2f
//Also see post with this subject: "using crs: image.projection() for exporting Landsat images"

//example crsTransform (from projection()), mapped to gdalinfo entries
/*
transform: List (6 elements)
0: 0.000277777777777778 (first "Pixel Size" element)
1: 0
2: -0.000138889 (First "Origin" element. Upper left corner of upper left pixel).
3: 0
4: -0.000277777777777778 (second "Pixel Size element)
5: 60.000138889000006 (Second "Origin" element. Upper left corner of upper left pixel).
*/

//From Hancher (subject: export global image to asset): 
// "For a global export, what I generally do is specify this, with no "region":"
//Strange, seems some of this was cut off??

/*crs: "EPSG:4326",
  crsTransform: [scale, 0, -180, 0, -scale, 90],
  dimensions: width + 'x' + height,*/

//Tyler Erickson on setting projection after doing ee.ImageCollection.reduce().
/* This commonly trips people up... ee.ImageCollection.reduce() reduces the collection to a single element (image), but 
because the collection may contain images with different CRSs, it does not assign a specific CRS to the resulting image.

In the case that you do have a collection of images that share the same CRS, you can extract a sample image and use its 
CRS for reduced image. Here is an example: https://code.earthengine.google.com/1e4dbac964b426cd4da1346333e7e507
*/

//When an image collection is a composite of images, the collection receives the projection EPSG:4326, [1,0,0,0,1,0],
//  even if all images in the collection have the same projection. If you know all images have the same projection
//  you can set the projection on the collection using setDefaultProjection. Here is an example:
//https://code.earthengine.google.com/f1770a1ddfbe59677ef2357fdc3ad916

//Example of using projection.wkt property instead of crs
//Note that reproject also does raster snapping
//https://code.earthengine.google.com/e42b7d4e1727763379cbd54019b15eb0
nlcdTreeCover2011.projection().getInfo()
var transform = proj.transform,
  crs = proj.wkt;
  // crs = proj.crs; //some are tagged as crs
  
var snappedHansenTreeCover2000 = hansenTreeCover2000.reproject(crs, transform);

//------
//------ exporting assets ------
//------

//---- using scale vs. crs/crsTransform
// If exporting an entire scene, seems to give identical results using either scale or crs method
// *However* be careful if clipping before exporting. Confirmed that pixels are shifted using QGIS
//NOTE: In an email Noel suggests using crs from projection() and not specifying scale (or crsTransform)?
crs: cfsCollection.first().projection()

var nomScale = img.projection().nominalScale();

//fileNamePrefix - used to specify path within the bucket and the file name.
//  the extension is automatically added. e.g. my/path/file will result in my/path/file.tif

Export.image.toCloudStorage({
  image: img,
  description: 'my_img',
  bucket:'ee-output',
  fileFormat: 'GeoTIFF', //this might be the default
  fileNamePrefix: 'exampleExport',
  region: img.geometry(), //need to set the output geometry, else it will default to the playground window size
  //or can do region: img.geometry().bounds() if geometry is a strange shape
  scale: img.projection().nominalScale().getInfo(), //leave this out to accept default projection
  maxPixels:1e13
});

//Export a cloud optimized geotiff. Just need to add the formatOptions parameter
Export.image.toCloudStorage({
  image: dist,
  description: 'dist2urban',
  bucket:'mol-playground',
  fileFormat:'GeoTIFF', //this might be the default
  fileNamePrefix:'benc/projects/ms3/layers/dist2urban',
  region: region,
  crs: urban.projection().crs().getInfo(),
  scale: urban.projection().nominalScale().getInfo(),
  maxPixels:1e13,
  formatOptions: {
    cloudOptimized: true
  }
});

//-- export to GEE asset. 
//Note use of crsTransform or nominalScale
//Need to use crs so that it is populated on the task.
//Also need to use getInfo, otherwise the task won't populate correctly.
Export.image.toAsset({
  image: img,
  description: 'task name',
  assetId:'mylayer',
  region: img.geometry().bounds(), //geometry is a strange shape, just use bounds
  crs:img.projection().crs().getInfo(),
  //crsTransform:img.projection().getInfo().transform,
  scale:img.projection().nominalScale().getInfo()
  maxPixels:1e13
});

//---- Exporting tables ----

f.setGeometry(null) //Useful to remove geometry before export

Export.table.toCloudStorage({
    collection: anno,
    description: taskName + '_' + group,
    bucket: gcsBucket,
    fileNamePrefix: gcsPath + '/' + fileName + group + '_',
    fileFormat : 'csv'});

Export.table.toDrive({
  collection: featureCollection,
  description: 'exportTableExample',
  fileFormat: 'CSV',
  selectors: (["band","offset","slope","rsquare"]) //use this to pick the output columns. note system:index won't be output.
});

//----
//---- listing assets
//----
var items = ee.data.getList({id: '<path to folder>'})
var items = ee.data.getList({id: 'users/JunXiong1981/AHI'})
print(items)

//----
//---- RMSE ----//
//----

//https://code.earthengine.google.com/577c51f32d4e4349afee950e54001233

//----
//---- Clouds ----//
//----

//https://github.com/fitoprincipe/geetools-code-editor/wiki/Cloud-Masks

//This script has a cloud masking function. Compare to other functions.
//https://code.earthengine.google.com/4a896f69dde7fa675242aaf7584efd8b

//Study and learn this script (from Nicholas Clinton). Bits and approach are different from what I'm using.
//https://code.earthengine.google.com/643c86f713c64dea1d921358b8da0530

//Discussion of using different cloud masking algorithms (cFmask, cloudScore, others)
//https://groups.google.com/g/google-earth-engine-developers/c/qkSaZ5tBXWg/m/JMvWXFLxAQAJ

//Landsat 8 Collection 2, Level 2
//
// This example demonstrates the use of the Landsat 8 Collection 2, Level 2
// QA_PIXEL band (CFMask) to mask unwanted pixels. (User contributed, so verify correctness)
//https://code.earthengine.google.com/691115257996c309d349402317e4310a

//-- Landsat 8 --
// Take a closer look. Seems to mask bit 3 and 5.
//https://code.earthengine.google.com/a760f223ed1f7e5925ea94f198c547d7
function maskL8sr(image) {
  // Bits 3 and 5 are cloud shadow and cloud, respectively.
  var cloudShadowBitMask = (1 << 3);
  var cloudsBitMask = (1 << 5);
  // Get the pixel QA band.
  var qa = image.select('pixel_qa');
  // Both flags should be set to zero, indicating clear conditions.
  var mask = qa.bitwiseAnd(cloudShadowBitMask).eq(0)
                 .and(qa.bitwiseAnd(cloudsBitMask).eq(0));
  return image.updateMask(mask);
}

//Mosiac, filter by cloud/cloud shadow over Spain
//https://code.earthengine.google.com/d653edd684a02416d3910182cc465684
//https://gis.stackexchange.com/questions/271322/cloud-mask-in-surface-reflectance-landsat-8-test

//Another bitshifting approach, this is for sentinel-2
//https://code.earthengine.google.com/b540df41a2af5880ad18dd5fd59aafb4

//From Copericus example: https://developers.google.com/earth-engine/datasets/catalog/COPERNICUS_S2
function maskS2clouds(image) {
  var qa = image.select('QA60');

  // Bits 10 and 11 are clouds and cirrus, respectively.
  var cloudBitMask = 1 << 10;
  var cirrusBitMask = 1 << 11;

  // Both flags should be set to zero, indicating clear conditions.
  var mask = qa.bitwiseAnd(cloudBitMask).eq(0)
      .and(qa.bitwiseAnd(cirrusBitMask).eq(0));

  return image.updateMask(mask).divide(10000);
}

//-- Examples from ---//
// https://code.earthengine.google.com/?accept_repo=users%2Fvictoriainman%2FOkavangoDelta_TechnicalNote&scriptPath=users%2Fvictoriainman%2FOkavangoDelta_TechnicalNote%3AScript1-OkavangoDelta_LandsatComposites
// 1. Cloud masking functions
// Landsat 8 function from https://developers.google.com/earth-engine/datasets/catalog/LANDSAT_LC08_C01_T1_SR
function cloudMaskL8(image) {
  var cloudShadowBitMask = 1 << 3;  
  var cloudsBitMask = 1 << 5;
  var qa = image.select('pixel_qa');   
  var mask = qa.bitwiseAnd(cloudShadowBitMask).eq(0).and(qa.bitwiseAnd(cloudsBitMask).eq(0));
  return image.updateMask(mask);}

// Landsat 5 and 7 function from https://developers.google.com/earth-engine/datasets/catalog/LANDSAT_LE07_C01_T1_SR
var cloudMaskL57 = function(image) {
  var qa = image.select('pixel_qa');   
  var cloud = qa.bitwiseAnd(1 << 5).and(qa.bitwiseAnd(1 << 7)).or(qa.bitwiseAnd(1 << 3)); 
  var mask2 = image.mask().reduce(ee.Reducer.min());
  return image.updateMask(cloud.not()).updateMask(mask2);};


//--- Functions and modules ----//
//Implement default parameters
//https://code.earthengine.google.com/c55646044eee3eee72409be885521e0f

//---- Landsat 7 ----//

//Gap fill: https://stackoverflow.com/questions/55256739/slc-code-not-filling-all-landsat-7-sr-gaps/55271390#55271390

//----
//---- BRDF Correction
//----

//-- Landsat 8
//https://groups.google.com/forum/#!topic/google-earth-engine-developers/KDqlUCj4LTs
//https://code.earthengine.google.com/3a6761dea6f1bf54b03de1b84dc375c6
//D.P. Roy, H.K. Zhang, J. Ju, J.L. Gomez-Dans, P.E. Lewis, C.B. Schaaf, Q. Sun, J. Li, H. Huang, V. Kovalskyy, A general method to normalize Landsat reflectance data to nadir BRDF adjusted reflectance, Remote Sensing of Environment, Volume 176, April 2016, Pages 255-271

//---- Tasks ----//
//---------------//

//Message from yzq.yang on 2021-09-17: 
//run this function in the chrome console to bulk run pending tasks.

runTasks = function() {
    $$('.run-button' ,$$('ee-task-pane')[0].shadowRoot).forEach(function(e) {
         e.click();
    })

    $$('ee-table-config-dialog, ee-image-config-dialog').forEach(function(e) {
    var eeDialog = $$('ee-dialog', e.shadowRoot)[0]
var paperDialog = $$('paper-dialog', eeDialog.shadowRoot)[0]
    $$('.ok-button', paperDialog)[0].click()
    })
}
