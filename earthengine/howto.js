//---------------//
//---- links ----//
//---------------//

//Data request? https://code.google.com/a/google.com/p/ee-testers-external/issues/list
//Tools to use in playground. Cloud masking, others. https://github.com/fitoprincipe/geetools-code-editor
//Tool to auto click "Run". https://github.com/kongdd/GEE_Tools/blob/master/gee_monkey.js
//Tools for uploading to GEE: https://github.com/samapriya/geeup

// ---- code management ----//

//haven't tried this, but should be how to clone my repo to local
git clone https://earthengine.googlesource.com/users/benscarlson/default

//--------------------//
//---- geometries ----//
//--------------------//

//xMin, yMin, xMax, yMax
var rect = ee.Geometry.Rectangle([11.87669, 51.92500, 12.48346, 52.25738]);
Map.addLayer(rect);

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

//----
//---- ee.FeatureCollection ----//
//----

var fc = ee.FeatureCollection( //can also construct with single geometry, or list of geometries, list of features
  ee.Feature(
    ee.Geometry.Point([12.0756,52.1151])));

//----
//---- ee.ImageCollection ----//
//----

//to pull images from an imagecollection by index, convert to a list
var lst = ic.toList(5); //5 is max number of images to fetch from the collection
print(lst);
print(ee.Image(lst.get(0))); //get the frist image in the list

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

//masking
.updateMask() //only masks out currenly unmasked pixels
.unmask() // turns any currently masked pixels into a value, 0 by default. can pass a value in
var msk = img.select([0]).gt(0); //create a mask

//---- date/time ----

//both of these formats can be parsed natively by ee
print(ee.Date('2014-06-02'));
print(ee.Date('2014-06-02T05:50:06Z'));

//function to set human-readable timestamps on a collection
function textTs(img) {
  return img
    .set('time_start', ee.Date(img.get('system:time_start')))
    .set('time_end', ee.Date(img.get('system:time_end')));
}
mycol = mycol.map(textTs);

//-------------------//
//---- filtering ----//
//-------------------//

//filter an image collection to extract one image
var img = ee.ImageCollection("LANDSAT/LC8_L1T_8DAY_NDVI")
  .filterMetadata('system:index','equals','20130626')

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

//Visulications

//color points by month
var colors = ee.List (["ff5050","ff7d52","ffa852","ffd452","ffff52","d4ff52","a8ff52","7dff52","52ff52"])
var result = pb_20982_2008.map(function(f){
  var colorIndex = ee.Number(f.get('month')).min(8)
  return f.set('style', {color:colors.get(colorIndex)})
})

//palettes
//bright/aqua greenish to yellowish to red-orangeish
var palette = ['b5acff','8dcfff','7ffff9','71ff96','c0ff6d','eeff64','ffc952','ffaf38','ff471d'];
//EVI palette
var palette = 'FFFFFF,CE7E45,DF923D,F1B555,FCD163,99B718,74A901,66A000,529400,3E8601,207401,056201,004C00,023B01,012E01,011D01,011301';
//paint a set of polygons polyFC (with identification 'id') to image and visualize
//example: https://code.earthengine.google.com/849862c672e8e5028a4d86ee14cf8c36
Map.addLayer(ee.Image().int().paint(polyFC,'id').randomVisualizer())

{palette:'blue'} //can also do this in addLayer

//---- crs/crsTranform ----//

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

//------ exporting assets ------
//NOTE: In an email Noel suggests using crs from projection() and not specifying scale (or crsTransform)?
crs: cfsCollection.first().projection()

var nomScale = img.projection().nominalScale();

Export.image.toCloudStorage({
  image: img,
  description: 'my_img',
  bucket:'ee-output',
  //fileNamePrefix: 'exampleExport', //try this out. I think this is for adding folders in front of the file name
  region: img.geometry(), //need to set the output geometry, else it will default to the playground window size
  //or can do region: img.geometry().bounds() if geometry is a strange shape
  scale: img.projection().nominalScale().getInfo(), //leave this out to accept default projection
  maxPixels:1e13
});

//-- export to GEE asset. Note use of crs/crsTransform
Export.image.toAsset({
  image: herb,
  description: 'herbExportTask',
  assetId:'glc_landcover/herb',
  region: bare.geometry().bounds(), //geometry is a strange shape, just use bounds
  crs:'EPSG:4326',
  crsTransform:herb.projection().getInfo().transform,
  maxPixels:1e13
});

Export.table.toDrive({
  collection: featureCollection,
  description: 'exportTableExample',
  fileFormat: 'CSV',
  selectors: (["band","offset","slope","rsquare"]) //use this to pick the output columns. note system:index won't be output.
});

//----
//---- Clouds ----//
//----

//Mosiac, filter by cloud/cloud shadow over Spain
//https://code.earthengine.google.com/d653edd684a02416d3910182cc465684
//https://gis.stackexchange.com/questions/271322/cloud-mask-in-surface-reflectance-landsat-8-test
