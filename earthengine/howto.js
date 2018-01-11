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

//---- filtering ----

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

Map.addLayer(img.select([0]).mask(msk),{palette:palette});

//Visulications
//palettes
var palette = ['b5acff','8dcfff','7ffff9','71ff96','c0ff6d','eeff64','ffc952','ffaf38','ff471d'];

//paint a set of polygons polyFC (with identification 'id') to image and visualize
//example: https://code.earthengine.google.com/849862c672e8e5028a4d86ee14cf8c36
Map.addLayer(ee.Image().int().paint(polyFC,'id').randomVisualizer())

Export.table.toDrive({
  collection: featureCollection,
  description: 'exportTableExample',
  fileFormat: 'CSV',
  selectors: (["band","offset","slope","rsquare"]) #use this to pick the output columns. note system:index won't be output.
});
