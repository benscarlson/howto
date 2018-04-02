//---------------//
//---- links ----//
//---------------//

//Data request? https://code.google.com/a/google.com/p/ee-testers-external/issues/list
//Tools to use in playground. Cloud masking, others. https://github.com/fitoprincipe/geetools-code-editor
//Tool to auto click "Run". https://github.com/kongdd/GEE_Tools/blob/master/gee_monkey.js

// ---- code management ----//

//haven't tried this, but should be how to clone my repo to local
git clone https://earthengine.googlesource.com/users/benscarlson/default

//-------------------------//
//---- features ----//
//-------------------------//

var f = ee.Feature(
    ee.Geometry.Point([10.9736,52.4577]));

//get a bounding box
var pts_fc = ee.FeatureCollection(occTable);
var bbox = pts_fc.geometry().bounds();

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
var img = ee.Image().byte().paint(fc, "ID");

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

//palettes
//bright/aqua greenish to yellowish to red-orangeish
var palette = ['b5acff','8dcfff','7ffff9','71ff96','c0ff6d','eeff64','ffc952','ffaf38','ff471d'];
//EVI palette
var palette = 'FFFFFF,CE7E45,DF923D,F1B555,FCD163,99B718,74A901,66A000,529400,3E8601,207401,056201,004C00,023B01,012E01,011D01,011301';
//paint a set of polygons polyFC (with identification 'id') to image and visualize
//example: https://code.earthengine.google.com/849862c672e8e5028a4d86ee14cf8c36
Map.addLayer(ee.Image().int().paint(polyFC,'id').randomVisualizer())

//---- crs/crsTranform ----//

//See here for detailed explaination from Matt Hancher for how to set crs/crsTransform
//Subject: 'Assets and CRSs, how to use them properly in GEE?'
//https://goo.gl/y76A2f

//------ exporting assets ------
var nomScale = img.projection().nominalScale();

Export.image.toCloudStorage({
  image: img,
  description: 'my_img',
  bucket:'ee-output',
  //fileNamePrefix: 'exampleExport', //try this out. I think this is for adding folders in front of the file name
  region: img.geometry(), //need to set the output geometry, else it will default to the playground window size
  scale: img.projection().nominalScale().getInfo(),
  maxPixels:1e13
});

Export.table.toDrive({
  collection: featureCollection,
  description: 'exportTableExample',
  fileFormat: 'CSV',
  selectors: (["band","offset","slope","rsquare"]) //use this to pick the output columns. note system:index won't be output.
});
