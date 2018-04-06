nohup <command> & #what is the command for running a nohup job? 
jobs OR jobs -l #if you are still logged into the same shell, use: 
ps -ef | grep "<part of command name>"# to find the pid #if you have exited out of the shell use this (but, which is the pid)?
ps ax | grep "<part of command name>" #the first column is the pid
kill -9 <pid> #to kill the process
ps -u bc447 #see processes owned by bc447
top -U bc447 #use top to see processed owned by bc447

chown -R benc:benc data #change the user and group permissions for folder "data" to user: benc group: benc. also works on files

.bash_pofile #used for login shell (i.e remote in via ssh)
.bashrc #used for non-login shell (i.e. opening another shell after you've already logged in)

dpkg -i debfile.deb #install a .deb file

#copy a file to a directory that does not yet exist
#https://stackoverflow.com/questions/947954/how-to-have-the-cp-command-create-any-necessary-folders-for-copying-a-file-to-a
mkdir -p path/to/new/dir && cp myfile.csv "$_"

#move all files, including hidden files, to a new directory
shopt - s dotglob
mv dir1/* dir2

tar xvf myfile.tar.gz #unzip myfile.tar.gz
unzip file.zip -d my_folder #unzip a zip to a specific folder (useful to extract a large file directly to external drive)

# add folder 'bin' to your path: Edit .bashrc. (.bash_profile on a mac). Add the folder as below:
export PATH=$HOME/bin:$PATH

#download directory from remote machine to local machine
scp -r benc@litoria.eeb.yale.edu:/remote/path /local/path
#download all files in a directory to the cwd
scp benc@litoria.eeb.yale.edu:~/remote/path/* .
#upload file.txt from local machine to remote machine
scp /local/file.txt benc@litoria.eeb.yale.edu:/remote/file.txt

#download multiple files. this will download a total of 12 files, note {1..12} syntax
wget https://domain/CHELSA_prec_{1..12}_1979-2013_V1_1.zip

#unzip all the files you downloaded
for file in CHELSA_prec_{1..12}_1979-2013_V1_1.zip; do tar -xvf $file; done

grep ERROR log.txt | wc -l #count the number of lines in the file log.txt with the word ERROR in it

#This basically says, interpreting this from RIGHT to LEFT that the file, linux_course_notes.txt was created at 6:30 PM on July 10 and is 1892 bytes large. 
# It belongs to the group users (i.e, the people who use this computer). It belongs to bob in particular and it is one (1) file.
# the first "-" means a normal file.  if it were a directory it would have a d. permissions are owner, group, world.
# r - read, w - write, x - execute

-rw-r--r--  1  bob  users  1892  Jul 10  18:30 linux_course_notes.txt

#read is 4, write is 2, execute is 1
chmod 666 y.txt # -rw-rw-rw
chmod 755 y.txt # -rwxr-xr-x
chmod 777 y.txt # -rwxrwxrwx
chmod 600 y.txt # -rw-------

#can unzip a zip file on mac using tar. in some cases this is the only way to unzip zip files
tar -xvf myfile.zip

df -H #total and available disk space, in easily readable units

zcat < myfile.txt.gz|head -10 > myfile_head.txt #first 10 lines of a gzipped file

#---- manipulate file contents ----
gsplit -d -l 2 -a 2 myfile.csv myfile #if myfile has 6 lines, this makes myfile00, myfile01, myfile02. two lines each.
gsplit -d -C 1MB -a 2 myfile.csv myfile #use -C option to limit file sizes to less than 1MB

#on the first line, change the first instance of event_id to point_index
sed -i ".bak" "1s/event\_id/point\_index/" biofilt/bav_biofilt.csv

#insert a header into the beginning of the file. Note you need to have the line breaks in there.
# .bak makes a backup of the file first. use '' to not make a backup.
#I think there are some differences between unix and osx with the -i parameter
sed -i '.bak' '1i\
bird_id,date,time,gps_long,gps_lat,hight,speed,heading,acc_index,ODBA,behav,behav2
' sample.csv

#convert file with windows \r\n (?) endings to unix endings \n (?)
dos2unix myfile.csv #osx makes changes in place. unix do dos2unix myfile.csv myfile2.csv

#see non-printing characters in a file (for example \r and \n)
#https://stackoverflow.com/questions/800030/remove-carriage-return-in-unix
cat infile | od -c

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
sudo umount /dev/disk2s1
#ovolume and mount point names don't have to be the same. here, they are.
sudo /usr/local/bin/ntfs-3g /dev/disk2s1 /Volumes/WD_MyBook_4TB -olocal -oallow_other -ovolname=WD_MyBook_4TB
sudo rm -r 'My Book' #clean up after automount might not need this, now mount point is being removed correctly

#An A-Z Index of the Apple macOS command line (OS X)
#https://ss64.com/osx/
