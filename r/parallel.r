
detectCores() #show the number of cores (parallel package)

cl <- makeCluster(4) #4 is the number of cores
registerDoParallel(cl)
on.exit(stopCluster(cl)) #need to use on.exit to stop the cluster when fn exits

#MPI

#close the cluster to avoid the error message about improper exit
closeCluster(cl)
mpi.quit()
