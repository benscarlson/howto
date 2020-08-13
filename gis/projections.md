| proj | proj4 string |
|-------|----------------|
| WGS84 | +proj=longlat  |

+proj=longlat +ellps=WGS84 WGS84

+proj=longlat +datum=WGS84" WGS84

+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0 WGS84

+proj=aea +lat_1=43 +lat_2=62 +lat_0=30 +lon_0=10 +x_0=0 +y_0=0 +ellps=intl +units=m +no_defs albers

+proj=utm +zone=33 +ellps=WGS84 +units=m +no_defs UTM zone 33N

+proj=utm +zone=33 +south +ellps=WGS84 +datum=WGS84 +units=m +no_defs UTM zone 33S (note +south)
