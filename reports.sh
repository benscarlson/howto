#-- Merges jpg files into one pdf

#Use this one
img2pdf $out/jpg/*.jpg --output $out/donana.pdf #No loss of quality, slightly faster, exactly the same size compared to imagemagick

convert $dir/jpg/*.jpg -auto-orient $dir/bpm_huj_eobs_convert.pdf #Convert command from imagemagick

#-- Merges png files into one pdf
dir=$wd/segtest2/reports/donana

files=`ls $dir/png/`

mkdir $dir/png_off

for file in $files
do
  convert $dir/png/$file -background white -alpha remove -alpha off $dir/png_off/$file
done

img2pdf $dir/png_off/* -o $dir/bpm_donana.pdf
