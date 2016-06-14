as.data.frame(spdf) #convert SpatialPointsDataFrame spdf to a dataframe

#raster package
nlayers(mystack) #number of RasterLayers in the RasterStack
names(mystack) #the names of the RasterLayers in the RasterStack
extent(mystack) #extent of the RasterLayers in the RasterStack
mystack[[1]] #extract the first RasterLayer from the RasterStack
names(layer) <- 'layername' #set the name of RasterLayer to 'layername'
