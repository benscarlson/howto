//---- CLI ----

#---- upload a shapefile ----
#cd to the folder containing the layer. the "layer" is the folder that contains the shp and associated files

gsutil -m cp -r UTM_Zone_Boundaries gs://mol-playground/benc/ingest_ee

earthengine upload table gs://mol-playground/benc/ingest_ee/UTM_Zone_Boundaries/UTM_Zone_Boundaries.shp --asset_id users/benscarlson/ref/utmzones

#---- move all assets to another folder ----#

#seems no bulk way to do this! Use this little script

./gee_move_assets.sh
chmod +x gee_move_assets.sh

#gee_move_assets.sh script
assets=`earthengine ls projects/map-of-life/benc/scratch/l7_l8_ndvi_albert_8day`

for asset in $assets; do

		echo Moving asset $asset

		file=${asset##*/}
		dest=projects/map-of-life/benc/scratch/l8_ndvi_albert_8day/$file

    earthengine mv $asset $dest
done

#---- delete assets ----#
earthengine rm -r projects/map-of-life/benc/l8sr_ndvi_loburg_sum14_new --dry_run #use dry_run to see what would be deleted

#---- download from gcs
gsutil -m cp -r gs://benc/scratch/utmtest/* .
