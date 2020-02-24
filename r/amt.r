library(amt)

#See coded example from bioarxiv. Can be found in Zotero
#https://cran.r-project.org/web/packages/amt/vignettes/p1_getting_started.html
#https://cran.r-project.org/web/packages/amt/vignettes/p4_SSF.html

#---- workflow for single animal rsf ----#

trk <- dat %>% make_track(lon, lat, timestamp, crs = sp::CRS("+init=epsg:4326")) #make an track_xyt
trk <- dat %>% make_track(lon, lat, crs = sp::CRS("+init=epsg:4326")) #make a track_xy

trk <- random_points

#Plotting tracks. case_ is after using random_points()
ggplot(trk,aes(x=x_,y=y_,color=case_)) + geom_point()
