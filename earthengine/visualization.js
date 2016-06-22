//palettes
var palette = ['b5acff','8dcfff','7ffff9','71ff96','c0ff6d','eeff64','ffc952','ffaf38','ff471d'];

//paint a set of polygons polyFC (with identification 'id') to image and visualize
Map.addLayer(ee.Image().int().paint(polyFC,'id').randomVisualizer())
