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
