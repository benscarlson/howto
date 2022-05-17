L1T - Precision terrain corrected. Includes radiometric correction, systematic geometric correction, precision correction using ground control. Uses DEM to correct parallax error due to local topographic relief
L1Gt - Insufficient ground control (often due to clouds). 

### Tile selection

Roy et al. 2016
* CONUS
* Three winter months (Dec-Feb)
* Three summer months (Jun-Aug)
* L1T
* GEOMETRIC_RMSE_MODEL <= 30m (ensures geolocation accuracy between L7 & L8)
* SUN_ELEVATION > 5* (Daylight acquisitions)

### L1T to reflectance

TOA reflectance is unitless (sometimes called the bi-directional reflectance factor)

Roy et al. 2016

Convert L7 L1T to TOA reflectance
* L1T stored as an 8-bit digital number
* Convert to spectral radiance using sensor calibration gain and bias coefficients stored in LT file metadata
* Radiance is then converted to TOA reflectance using formula using Dearth-Sun distance, ESUN, solar zenieth angle, etc.

Convert L8 L1T to TOA reflectance
* L1T stored as a 16-bit digital number
* Also have to to scaling, might be the same as L7

### Saturation

Discarded saturated pixels
* L7 - stored as specific ETM+ L1T digital numbers
* L8 - compare to OLI L1T metadata saturation values


OLI are saturated less frequently than ETM+ b/c OLI has greater dynamic range.

### Clouds

L8 - has cloud, cirrus cloud, snow masks

Roy et al. 2016 
* ETM+ used ACCA and a Decision Tree algorithm. Discarded pixel if either algorithm reported cloudy conditions (assume binary?)
* OLI uses the included cloud information. Adopted a generous cloud definition.
  * High or medium confidence cloud
  * High or confidence cirrus
  * High or medium confidence snow

### Surface Reflectance

Roy et al. 2016
* Both use LEDAPS
* Removed values outside 0-1 range

### Landcover change

Roy et al. 2016
* Applied filter that discarded pixels that has blue TOA reflectance difference greater than 100% of their average.
* Will also remove pixels where either (but not both) pixels are cloud/snow contaminated.

### Reprojection

Each tile independently projected using Albers equal area (nearest neighbor resampling) into fixed 5000x5000 30m tiles. These are known as WELD tiles
Did this for each week.
Not totally clear what they did here.

### Sampling

* Sampled from tiles that were one day apart
* Sampled every 20th pixel (in row and column directions)

### Statistical modeling

* RMA regression
* OLS regression

#### Roy et al. 2015

* Overlap region is captured in forward direction with one sensor and backward with other. So need many months of data to balance BDRF effects

  
