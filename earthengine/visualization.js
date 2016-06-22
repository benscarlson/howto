//palettes
var palette = ['b5acff','8dcfff','7ffff9','71ff96','c0ff6d','eeff64','ffc952','ffaf38','ff471d'];

//paint a set of polygons polyFC (with identification 'id') to image and visualize
//example: https://code.earthengine.google.com/849862c672e8e5028a4d86ee14cf8c36
Map.addLayer(ee.Image().int().paint(polyFC,'id').randomVisualizer())
