
#---- import data ----#

ppp1 <- as.ppp(SpatialPoints(spdf1)) #as.ppp is in maptools package. spdf1 is a SpatialPointsDataFrame
unitname(ppp1) <- c('degree','degrees') #set unit names

#see here for example importing a point dataset into spatstat
#http://rstudio-pubs-static.s3.amazonaws.com/5273_fbda8993a4904f7e8c64e6c3da5ce7c6.html
