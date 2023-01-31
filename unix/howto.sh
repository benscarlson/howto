#---- references ----#
#https://medium.com/@kadek/command-line-tricks-for-data-scientists-c98e0abe5da

#seems macos uses .bash_profile and not bashrc
.bash_pofile #used for login shell (i.e remote in via ssh)
.bashrc #used for non-login shell (i.e. opening another shell after you've already logged in)

dpkg -i debfile.deb #install a .deb file

#---- create folders ----#
mkdir -p ~/projects/oilbirds/analysis/$datName && cd "$_" #make a folder and cd to it

#---- listing files ----#

ls -lh #human-readable file sizes
du -h mydir #total size of directory (also lists all files underneath mydir)
du -h --threshold=1G #only show dirs above 1G
du -hsc mydir #just the total file size of mydir
du -h myfile.txt #size of file in human-readable units

#Reading output from ls
# This basically says, interpreting this from RIGHT to LEFT that the file, linux_course_notes.txt was created at 6:30 PM on July 10 and is 1892 bytes large. 
# It belongs to the group users (i.e, the people who use this computer). It belongs to bob in particular and it is one (1) file.
# the first "-" means a normal file.  if it were a directory it would have a d. permissions are owner, group, world.
# r - read, w - write, x - execute

-rw-r--r--  1  bob  users  1892  Jul 10  18:30 linux_course_notes.txt

#include full paths with files
ls -d "$PWD"/*
ls -d "$PWD"/my_folder/*

#---- reading file contents ----#

#Two methods for printing the number of lines in a file
wc -l $csv | awk '{print $1}'
cat $csv | wc -l

#---- finding files and directories ----#
sudo find / -size +500000 -print

#---- copying files ----#

#copy a file to a directory that does not yet exist
#https://stackoverflow.com/questions/947954/how-to-have-the-cp-command-create-any-necessary-folders-for-copying-a-file-to-a
mkdir -p path/to/new/dir && cp myfile.csv "$_"

#---- moving files ----#

#move all files, including hidden files, to a new directory
shopt - s dotglob
mv dir1/* dir2

#---- deleting files ----#

find . ! -name 'file.txt' -type f -exec rm -f {} + #delete all files in directory, except for 'file.txt'. https://unix.stackexchange.com/questions/153862/remove-all-files-directories-except-for-one-file

#---- file permissions ----#
chown -R benc:benc data #change the user and group permissions for folder "data" to user: benc group: benc. also works on files
#read is 4, write is 2, execute is 1
chmod 666 y.txt # -rw-rw-rw
chmod 755 y.txt # -rwxr-xr-x
chmod 744 y.txt # -rwxr--r--
chmod 777 y.txt # -rwxrwxrwx
chmod 600 y.txt # -rw-------

#---- executing files ----#
chmod 744 ~/projects/rsf/src/scripts/report_runcopy.r #make file executeable
ln -s ~/projects/rsf/src/scripts/report_runcopy.r knitcopy #make a softlink in ~/bin

#---- file archives ----#

zipinfo -1 file.zip #list files (and dir structure) in archive
unzip -Zt file.zip #list the total uncompressed file size

unzip file.zip -d my_folder #unzip a zip to a specific folder (useful to extract a large file directly to external drive)
unzip file.zip filename.tif #extract just filename.tif from the archive

tar xvf myfile.tar.gz #unzip myfile.tar.gz
tar -C #unzip directly to folder
tar -xzvf #x: extract, z: filter through gzip, v: verbose, f:use archive
tar --strip-components=n #string the first n folders from the file
tar -xzvf file.zip file1.txt #extract just file1.txt from the archive

#can unzip a zip file on mac using tar. in some cases this is the only way to unzip zip files
tar -xvf myfile.zip

#unzip all the files you downloaded
for file in CHELSA_prec_{1..12}_1979-2013_V1_1.zip; do tar -xvf $file; done

zcat < myfile.txt.gz|head -10 > myfile_head.txt #first 10 lines of a gzipped file

# add folder 'bin' to your path: Edit .bashrc. (.bash_profile on a mac). Add the folder as below:
export PATH=$HOME/bin:$PATH

#---- remote download/upload files ----#

#download directory from remote machine to local machine
scp -r benc@litoria.eeb.yale.edu:/remote/path /local/path
#download all files in a directory to the cwd
scp benc@litoria.eeb.yale.edu:~/remote/path/* .
#upload file.txt from local machine to remote machine
scp /local/file.txt benc@litoria.eeb.yale.edu:/remote/file.txt
#upload all files and folders in current directory to remote directory huj_eobs_test
scp -r * bc447@grace.hpc.yale.edu:~/results/huj_eobs_test
#upload the ms1 folder (and all contents) to the ~/projects directory
scp -r ms1 bc447@grace.hpc.yale.edu:~/projects

#Handling ~ expansion
#SCP doesn't expand ~. But you need to have ~ in path if you want local and remote to have the same structure
wd=~/path #This will not work, because it will be expanded to /user/benc/path which doesn't exist on the remote machine
wd="~/path" #This won't expand, but now you have to expand manually in scp
scp ${wd/#\~/$HOME}/path/file.csv grace:$wd/path

#download multiple files. this will download a total of 12 files, note {1..12} syntax
wget https://domain/CHELSA_prec_{1..12}_1979-2013_V1_1.zip

#---- reading file contents ----#
grep ERROR log.txt | wc -l #count the number of lines in the file log.txt with the word ERROR in it
sed 'NUMq;d' file #read a particular line of a file. https://stackoverflow.com/questions/6022384/bash-tool-to-get-nth-line-from-a-file
tail -n +2 file.csv #print all lines, starting at line 2 (i.e. skip file header)
find . -type f -exec cat {} + | wc -l #sum of total lines in all files

#---- disk management ----#
df -H #total and available disk space, in easily readable units

#---- manipulate file names ----#
rename 's/old/new/g' * #replaces 'old' with 'new' for all files. note on osx, need to do 'brew install rename'

# Make a copy of .bash_profile with a timestamp suffix
ts=.bash_profile_`date +%Y-%m-%d_%H-%M-%S`
cp ~/.bash_profile ~/${ts}

#---- Dates ----#

date +%Y-%m-%d #Format today's date as yyyy-mm-dd

#---- manipulate file contents ----
gsplit -d -l 2 -a 2 myfile.csv myfile #if myfile has 6 lines, this makes myfile00, myfile01, myfile02. two lines each.
gsplit -d -C 1MB -a 2 myfile.csv myfile #use -C option to limit file sizes to less than 1MB

#on the first line, change the first instance of event_id to point_index
sed -i ".bak" "1s/event\_id/point\_index/" biofilt/bav_biofilt.csv

# Add a line to the end of .bash_profile
echo "export BREEZY_HOME=${breezy_home}" >> ~/.bash_profile

#insert a header into the beginning of the file. Note you need to have the line breaks in there.
# .bak makes a backup of the file first. use '' to not make a backup.
#I think there are some differences between unix and osx with the -i parameter
sed -i '.bak' '1i\
bird_id,date,time,gps_long,gps_lat,hight,speed,heading,acc_index,ODBA,behav,behav2
' sample.csv

#replace all '-' with '_' in first row of file
# -i means in place, '' means no backup. 1s means first line only. \ is escape character
sed -i '' '1s/\-/\_/g' event_raw.csv

#convert file with windows \r\n (?) endings to unix endings \n (?)
dos2unix myfile.csv #osx makes changes in place. unix do dos2unix myfile.csv myfile2.csv

#see non-printing characters in a file (for example \r and \n)
#https://stackoverflow.com/questions/800030/remove-carriage-return-in-unix
cat infile | od -c

#---- user management ----#
id -un #get current users (might only work for mac?)
whoami

#---- process management ----#
Ctrl-C #sends SIGINT to process (should terminate it)
Ctrl-Z #sends SIGSTOP to process (will pause it)

nohup <command> & #what is the command for running a nohup job? 
jobs OR jobs -l #if you are still logged into the same shell, use: 
ps -ef | grep "<part of command name>"# to find the pid #if you have exited out of the shell use this (but, which is the pid)?
ps ax | grep "<part of command name>" #the first column is the pid
kill -9 <pid> #to kill the process
ps -u bc447 #see processes owned by bc447
top -U bc447 #use top to see processed owned by bc447

#---- curl ----#
#write session cookie to file then accept. note use of -c and -b
curl -v -u <user>:<pass> -c cookies.txt -o license_terms.txt "https://www.movebank.org/movebank/service/direct-read?entity_type=event&study_id=685178886"

md5 -r ~/scratch/license_terms.txt

curl -v -u <user>:<pass> -b cookies.txt -o event_data.csv "https://www.movebank.org/movebank/service/direct-read?entity_type=event&study_id=685178886&license-md5=31bf56775d156bbc7aeb2986e00dff28" 

#---- wget ----#
wget -O individuals.csv --user "ben.s.carlson" --password $pass $url

#----------
#   OSX   
#----------
sysctl -n hw.ncpu #the number of logical cores
sysctl hw.logicalcpu #also the number of logical cores
sysctl hw.physicalcup #the number of physical cores

system_profiler SPHardwareDataType #a bunch of information about processor, ram, etc.
system_profiler SPCardReaderDataType #information about SDCard

#to see details about printers:
http://localhost:631/printers

#---- mount WD MyBook ----#
# adapted from https://www.howtogeek.com/236055/how-to-write-to-ntfs-drives-on-a-mac/
# https://github.com/osxfuse/osxfuse/issues/342 see here for recent sierra issue

sudo umount /dev/disk3s1
#ovolume and mount point names don't have to be the same. here, they are.
sudo /usr/local/bin/ntfs-3g /dev/disk3s1 /Volumes/WD_MyBook_4TB -olocal -oallow_other -ovolname=WD_MyBook_4TB
sudo rm -r 'My Book' #clean up after automount might not need this, now mount point is being removed correctly

#An A-Z Index of the Apple macOS command line (OS X)
#https://ss64.com/osx/

#---- homebrew ----#
brew list #list packages
brew list --versions #also list package versions
brew upgrade <package> #upgrade a package

