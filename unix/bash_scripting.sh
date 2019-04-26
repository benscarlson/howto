#create and use a variable
MYFOLDER='folder_name'
ls $MYFOLDER #lists all files in folder_name
echo ls $MYFOLDER #see the resulting command

#set variable to output of a command. Either method below works.
numlines1=$(cat $dat | wc -l)
numlines1=`cat $dat | wc -l`

#variable contains a list of files (seperated by space)
# can be used as input to commands that take a 1 to n file names
files=`ls`
echo $files

#---- path manipulation ----#
filePF=/path/to/file.txt

#Below uses parameter expansion
# https://opensource.com/article/17/6/bash-parameter-expansion
echo ${filePF%.*} #/path/to/file ##full path and file without extention
echo ${filePF%.txt} #/path/to/file ##same as above full path and file without extention
echo ${filePF%/*} #/path/to ##full path no file
echo ${filePF##*/} #file.txt

fn=${filePF##*/} #gets the file name
echo ${fn%.csv} #strips off file extenstion. useful for getting dsn

#---- pass in arguments ----#

#use getopts: https://www.lifewire.com/pass-arguments-to-bash-script-2200571

#-- export command --#
# export will make variable available to child processes
shellvar=1
export envvar=2
bash #spawn child process
echo $shellvar #nothing
echo $envvar #prints '2'

#--- if/then statements ----#
if [ "$dat" == "$datPath" ]; then
  dlP=raw
else
  dlP=$datPath/raw
fi

if [$nline1 -ne $nline2]; then echo 'Number of rows is not equal!'

#--- loop through an array ---#
declare -a arr=("50N_010E" "50N_010E" "60N_000E" "60N_010E")

## now loop through the above array
for i in "${arr[@]}"
do
   tar -xzvf Hansen_GFC2013_datamask_"$i".tif.zip --strip-components=6 Stornext/scienceweb1/development/gtc/downloads/WaterMask2010_UMD/Hansen_GFC2013_datamask_"$i".tif
done

tifs=`ls *.tif` #save the list of files to the tifs variable

#--- bash arrays and loops ----#
The weird, wondrous world of Bash arrays. https://medium.com/@robaboukhalil/the-weird-wondrous-world-of-bash-arrays-a86e5adf2c69
