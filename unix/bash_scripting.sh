#---- run a bash script from commandline ----#
#!/bin/bash #put this at the beginning of the line
chmod 755 myscript.sh
ln -s ~/myscript.sh myscript #make a softlink in ~/bin

#create and use a variable
MYFOLDER='folder_name'
ls $MYFOLDER #lists all files in folder_name
echo ls $MYFOLDER #see the resulting command

#set variable to output of a command. Either method below works.
numlines1=$(cat $dat | wc -l)
numlines1=`cat $dat | wc -l`

#Reading variables from files can result in nonprintable characters eg \n, \r, etc.
#https://unix.stackexchange.com/questions/32001/what-is-m-and-how-do-i-get-rid-of-it#:~:text=Show%202%20more%20comments,marked%20by%20a%20single%20newline.
#https://stackoverflow.com/questions/64758213/stop-inserting-newline-before-comma/64766076#64766076
echo $myvar | cat -ve #this will print symbols for non printing chars. eg. ^M for \r
myvar=${myvar%$'\r'} #this strips \r from the variable
#above, $'\r' converts the string "\r" to return
#${myvar%suffix} removes suffix

#-- lists 
lst=("one" "two" "three")
echo ${lst[0]} # one

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
#https://stackoverflow.com/questions/11742996/shell-script-is-mixing-getopts-with-positional-parameters-possible
#https://web.archive.org/web/20130927000512/http://www.devhands.com/2010/01/handling-positional-and-non-positional-command-line-arguments-from-a-shell-script/
#https://sookocheff.com/post/bash/parsing-bash-script-arguments-with-shopts/

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

#note can just say arr=("one" "two"), at least in interactive shell
declare -a arr=("50N_010E" "50N_010E" "60N_000E" "60N_010E")

## now loop through the above array
for i in "${arr[@]}"
do
   tar -xzvf Hansen_GFC2013_datamask_"$i".tif.zip --strip-components=6 Stornext/scienceweb1/development/gtc/downloads/WaterMask2010_UMD/Hansen_GFC2013_datamask_"$i".tif
done

tifs=`ls *.tif` #save the list of files to the tifs variable

#--- bash arrays and loops ----#
The weird, wondrous world of Bash arrays. https://medium.com/@robaboukhalil/the-weird-wondrous-world-of-bash-arrays-a86e5adf2c69

#---- Input parameters ----#

#http://try.docopt.org/
