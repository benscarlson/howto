
detectCores() #show the number of cores (parallel package)
getDoParName() #this shows while parallel backend is registered

cl <- makeCluster(4) #4 is the number of cores
registerDoParallel(cl)
on.exit(stopCluster(cl)) #need to use on.exit to stop the cluster when fn exits

#MPI
mpi.universe.size() #this should be the number of cores. on my laptop, it is 8
#close the cluster to avoid the error message about improper exit
closeCluster(cl)
mpi.quit()
