nohup <command> & #what is the command for running a nohup job? 
jobs OR jobs -l #if you are still logged into the same shell, use: 
ps -ef | grep "<part of command name>"# to find the pid #if you have exited out of the shell use this (but, which is the pid)?
ps ax | grep "<part of command name>" #the first column is the pid
kill -9 <pid> #to kill the process
chown -R benc:benc data #change the user and group permissions for folder "data" to user: benc group: benc. also works on files

.bash_pofile #used for login shell (i.e remote in via ssh)
.bashrc #used for non-login shell (i.e. opening another shell after you've already logged in)

dpkg -i debfile.deb #install a .deb file

#move all files, including hidden files, to a new directory
shopt - s dotglob
mv dir1/* dir2

tar xvf myfile.tar.gz #unzip myfile.tar.gz
unzip file.zip -d my_folder #unzip a zip

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

#----------
#   OSX   
#----------
sysctl -n hw.ncpu #the number of logical cores
sysctl hw.logicalcpu #also the number of logical cores
sysctl hw.physicalcup #the number of physical cores

system_profiler SPHardwareDataType #a bunch of information about processor, ram, etc.

#can unzip a zip file on mac using tar. in some cases this is the only way to unzip zip files
tar -xvf myfile.zip

df -H #total and available disk space, in easily readable units

zcat < myfile.txt.gz|head -10 > myfile_head.txt #first 10 lines of a gzipped file
