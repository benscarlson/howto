### grace-next ###

#set up ssh key for grace-next using these instructions 
#https://confluence.atlassian.com/bitbucket/set-up-ssh-for-git-728138079.html

/gpfs/apps/hpc.rhel6/Apps/R/3.2.2-generic/lib/R/library #location of system r packages
~/R/x86_64-pc-linux-gnu-library/3.2 #personal library

#nodes on grace-next have 20 cores each
#interactive partition: limited to 4 tasks
#day partition: 13 nodes
#week partition: 24 nodes

#SLURM#
srun --pty -p interactive -c 1 -t 0:30:00 --mem-per-cpu=20000 bash #start an interactive session with 20GB of memory
sbatch myscript.sh #submit the job. parameters and script defined in myscript.sh
squeue -l -u bc447 #see job status
srun --pty -p interactive -n 4 bash #equest four tasks for an hour, you could use
scancel <jobid>

#test an mpi parallel script in interactive queue
srun --pty -p interactive -n 4 bash #request four tasks in the interactive queue
mpirun -n 4 R --slave -f myparscript.r #use mpi run to kick off the script using four parallel processes

### omega ###
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

