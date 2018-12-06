#---- installation ----#
library(devtools)
install_local('~/projects/anno',dependencies=FALSE,quiet=TRUE) #won't install unless code changed
library(anno)

#update namespace file (required to export functions)
devtools::document()

#note, if you get something like "... *.rdb is corrupt" restart r session and try again
.rs.restartR()

#get the full path of a specified file in a package
system.file("external/test.grd", package="raster")

#after updating the package, do this in rstudio
devtools::document()
devtools::build()
