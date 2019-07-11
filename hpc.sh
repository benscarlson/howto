#--------------------
#---- grace ----
#--------------------

#---- git configuration ----#

# need to set up key for computer/cluster you want to use to access github

#-- github
# 1) use public key at ~/.ssh/id_rsa.pub
# 2) add this as an ssh key to github: https://github.com/settings/keys
# 3) git clone git@github.com:<user>/<repo>.git

#-- bitbucket 
#https://confluence.atlassian.com/bitbucket/set-up-ssh-for-git-728138079.html

#---- R configuration ----

#-- install required packages
# can do this in the login node
module avail R #find the most recent version of R
#module load Apps/R
module load Apps/R/3.5.1-generic
#run R, then do install.packages() for all the packages you need


#This is old, for 3.2. Prolly similar for 3.5
#/gpfs/apps/hpc.rhel6/Apps/R/3.2.2-generic/lib/R/library #location of system r packages
#~/R/x86_64-pc-linux-gnu-library/3.2 #personal library

#---- configuration ----#
#nodes on grace-next have 20 cores each
#interactive partition: limited to 4 tasks
#day partition: 13 nodes
#week partition: 24 nodes
#pi_jetz: 2 nodes, 28 cores/node. 256G max per node. 
/gpfs/apps/bin/groupquota.sh #see report on group quota

#jetz group
#shared directory: /project/fas/jetz/data

umask 0002 #add this to ~/.bashrc file to make sure files you create are going to be editable and movable by your fellow group members
#---- SLURM ----#

# slurm script 
#SBATCH --mem-per-cpu=32G

srun --pty -p interactive -c 1 -t 0:30:00 --mem-per-cpu=20000 bash #start an interactive session with 20GB of memory
sbatch myscript.sh #submit the job. parameters and script defined in myscript.sh
srun --pty -p interactive -n 4 bash #equest four tasks for an hour, you could use

#to run an mpi job in interactive shell
srun --pty -p interactive -n 4 bash 
mpirun -n 4 R --slave -f ~/projects/whitestork/src/scripts/hv/nichetest_hpc.r --args $job

# see job status
squeue -l -u bc447 #see job status for user bc447
squeue -p interactive #see job status for interactive queue

sacct -j <jobid> --format=JobID,JobName,Partition,AllocCPUS,MaxRSS,Elapsed
sacct -u <username> --format=JobID,JobName,Partition,AllocCPUS,MaxRSS,Elapsed

scancel <jobid>

#test an mpi parallel script in interactive queue
srun --pty -p interactive -n 4 bash #request four tasks in the interactive queue
module load Apps/R
module load Apps/R/3.5.1-generic
module load Rpkgs/DOMPI
mpirun -n 4 R --slave -f myscript.r #use mpi run to kick off the script using four parallel processes
mpirun -np 1 #only start script on one task

# submit a job
sbatch myscript_sbatch.sh

#--------------------
#---- omega ----
#--------------------
ssh bc447@omega.hpc.yale.edu #log in to omega
qsub -q fas_devel -I #request interactive queue on fas_devel
#omega queues: http://research.computing.yale.edu/support/hpc/clusters/omega
module load Apps/R/3.3.2-generic #uses specific version
module load Apps/R #uses default version
module avail 

#default system directory for installing packages
/lustre/home/client/apps/fas/Rpkgs/RCPP/1.12.1/3.2

#personal library
/lustre/home/client/fas/jetz/bc447/R/x86_64-pc-linux-gnu-library/3.2/

