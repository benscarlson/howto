library(amt)

#See coded example from bioarxiv. Can be found in Zotero

#---- workflow for single animal rsf ----#

trk <- make_track(dat, lon, lat, timestamp, crs = sp::CRS("+init=epsg:4326"))
