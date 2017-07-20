//filter an image collection using metadata field by list
var col = ee.ImageCollection('MODIS/MOD11A2');
var images = ['MOD11A2_005_2014_12_27','MOD11A2_005_2014_12_27'];
var filt = ee.Filter.inList({leftField:'system:index',leftValue:null,rightField:null,rightValue:images});
