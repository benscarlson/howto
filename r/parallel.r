


detectCores() #show the number of cores (parallel package)
getDoParName() #this shows which parallel backend is registered

cl <- makeCluster(4, outfile='mylogfile.log') #4 is the number of cores. part of parallel package
registerDoParallel(cl) #part of doParallel package
stopCluster(cl) #part of parallel package

#MPI
mpi.universe.size() #this should be the number of cores. on my laptop, it is 8
#close the cluster to avoid the error message about improper exit
closeCluster(cl)
mpi.quit()
