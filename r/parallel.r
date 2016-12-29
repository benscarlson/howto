
detectCores() #show the number of cores (parallel package)

cl <- makeCluster(4) #4 is the number of cores
registerDoParallel(cl)
on.exit(stopCluster(cl)) #need to use on.exit to stop the cluster when fn exits
