//---- CLI ----

#---- upload a shapefile ----
#cd to the folder containing the layer. the "layer" is the folder that contains the shp and associated files

gsutil -m cp -r UTM_Zone_Boundaries gs://benc/export_to_ee

earthengine upload table gs://benc/export_to_ee/UTM_Zone_Boundaries/UTM_Zone_Boundaries.shp --asset_id users/benscarlson/ref/utmzones

#---- delete assets ----#
earthengine rm -r projects/map-of-life/benc/l8sr_ndvi_loburg_sum14_new --dry_run #use dry_run to see what would be deleted

#---- download from gcs
gsutil -m cp -r gs://benc/scratch/utmtest/* .
