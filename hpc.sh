#---- Access ----#

#Access using GUI (e.g. browser or rstudio): https://docs.ycrc.yale.edu/clusters-at-yale/access/ood/
#Some bash functions from Kevin for accessing the hpc: /Users/benc/Documents/people/kevin/Gmail - Acces to the HPC through the portal.pdf

# See this document for how to load hostname shortcuts for the hpc
# https://docs.ycrc.yale.edu/clusters-at-yale/access/advanced-config/

ssh user@grace.hpc.yale.edu #Instead of this
ssh grace #Do this

#---- General development workflow ----#

# * Run script sequentially, interactive mode on local machine
# * Run script in parallel, interactive mode on local machine
# * Run script sequentially, script mode on local machine
# * Run script in parallel, script mode on local machine
# * Upload code to grace using scp or git

#Use env variables to pass to sbatch
#https://help.rc.ufl.edu/doc/Using_Variables_in_SLURM_Jobs
sbatch --export=A=5,b='test' jobscript.sbatch #see link for more examples

#--------------------
#---- grace ----
#--------------------

#---- commandline vpn ----#
#See email from Kevin, Yanni for more information
/opt/cisco/anyconnect/bin/vpn connect access.yale.edu

#I created alias 'vpn' to above, so now connect/disconnect like this
vpn connect access.yale.edu
vpn disconnect

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

#---- doMC ----#
RNGkind("L'Ecuyer-CMRG") #set random numbers
#This gets cores, which is set by -c. When using doMC, need to use -c, not -n
cores <- strtoi(Sys.getenv('SLURM_CPUS_PER_TASK', unset=1)) #for testing on hpc

#---- doMPI ----#

# don't need to set number of nodes, etc if executing from slurm script
# in slurm, use -n to set the number of tasks
cl <- startMPIcluster(verbose=TRUE,logdir='mylogdir') #MPI_*.out files will be written to mylogdir
registerDoMPI(cl)
setRngDoMPI(cl) #set each worker to receive a different stream of random numbers

#---- SLURM ----#

#Documentation
#https://docs.ycrc.yale.edu/clusters-at-yale/job-scheduling/

#-- slurm script 

#Basic commands for slurm:
#SBATCH -n 20 #use -n for mpi
#SBATCH -t 60:00 #this is 60 min
#SBATCH -p day #use day partition
#SBATCH --mail-type=ALL
#SBATCH --mail-user=email@email.com

#Additional commands:
--mem-per-cpu=32G
-J myjob  #job name
-e --error. default is slurm-%j.out
-o --output. default is slurm-%j.out

#Can also combine commands
#SBATCH -n 20 -t 60:00

#---- Command line parameters ----#

#-- Workflow script

#Need to export variables used in the sbatch script
export src=$pd/src
export sesnm=main

#Slurm variables. Don't need to export.
t=23:59:59
p=day
J=umap4_2k
mail=NONE
log=umap4_2k.log
mem=64G

#Note passed in variable takes precedence over #SLURM variable in a script
sbatch -p $p -t $t -J $J -e $log -o $log --mail-type $mail --mem-per-cpu $mem $src/main/umap/umap-sbatch.sh 

#-- sbatch script

#!/bin/bash

module load R

Rscript --vanilla $src/main/umap/umap.r $sesnm

#---- Interactive Shell ----#

#to run an mpi job in interactive shell
#NOTE: this is the new way
#https://docs.ycrc.yale.edu/clusters-at-yale/job-scheduling/
salloc -t 2:00:00 --mem=16G

module load R

#Install packages
R
cran <- 'http://lib.stat.cmu.edu/R/CRAN/'
install.packages('umap',repos=cran)
q()

#-- Directly run a script
Rscript --vanilla $src/main/umap/umap.r main $hvs 10 data/umap_10 --db $db -e hypervol -c $ctfs

#NOTE: this is the old way
srun --pty -p interactive -c 1 -t 0:30:00 --mem-per-cpu=20000 bash #start an interactive session with 20GB of memory
sbatch myscript.sh #submit the job. parameters and script defined in myscript.sh
srun --pty -p interactive -n 4 bash #equest four tasks for an hour, you could use

srun --pty -p interactive -n 4 bash 
mpirun -n 4 R --slave -f ~/projects/whitestork/src/scripts/hv/nichetest_hpc.r --args $job

# see job status
squeue -l -u bc447 #see job status for user bc447
squeue -p interactive #see job status for interactive queue

sacct -j <jobid> --format=JobID,JobName,Partition,AllocCPUS,MaxRSS,Elapsed
sacct -u <username> --format=JobID,JobName,Partition,AllocCPUS,MaxRSS,Elapsed
sacct --format="Elapsed" -j <jobid> #Just output how much time has elapsed for the job
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

