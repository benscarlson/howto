reduceRegion(ee.Reducer.frequencyHistogram()) //compute number of distinct values in a histogram
reduceRegion(ee.Reducer.sum().grouped(1)) //use raster zonal area (zonal stats) to realize sum, max value calculation

var fc = (ee.FeatureCollection('ft:1Ec8IWsP8asxN-ywSqgXWMuBaxI6pPaeh6hC64lA')
      .filter(ee.Filter().eq('ECO_NAME', 'Sonoran desert')));
