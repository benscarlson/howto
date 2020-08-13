| proj | proj4 string | notes|
|-------|----------------|-|
| WGS84 | +proj=longlat  |
|WGS84 |+proj=longlat +ellps=WGS84 |
|WGS84 |+proj=longlat +datum=WGS84 |
|WGS84 |+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0 |
|albers | +proj=aea +lat_1=43 +lat_2=62 +lat_0=30 +lon_0=10 +x_0=0 +y_0=0 +ellps=intl +units=m +no_defs |
|UTM zone 33N | +proj=utm +zone=33 +ellps=WGS84 +units=m +no_defs |
| UTM zone 33S | +proj=utm +zone=33 +south +ellps=WGS84 +datum=WGS84 +units=m +no_defs | note +south|
|Azimuthul equidistant | "+proj=aeqd +lat_0=44.5 +lon_0=-69.8 +x_0=0 +y_0=0 +ellps=WGS84 +datum=WGS84 +units=m +no_defs" | lat_0, lon_0 centered on Maine |

## Proj4
* Syntax. https://mgimond.github.io/Spatial/coordinate-systems-in-r.html
* All available projections. https://proj.org/operations/projections/
