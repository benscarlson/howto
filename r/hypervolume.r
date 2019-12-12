#---- Usage Questions ----#
# When comparing hypervolumes, should I use a different bandwidth per hypervolumes, 
# or should I use the same bandwidth for all hypervolumes?

ceiling((10^(3 + sqrt(ncol(dat))))/nrow(dat)) #default for samples.per.point

#Jaccard index
hvset <- hypervolume_set(hv1,hv2,check.memory = FALSE)

#recommended number of observations is:
# obs > exp(number of axes)

hypervolume_overlap_statistics(hvset) #This will have Jaccard, plus others
hvset@HVList$Intersection@Volume / hvset@HVList$Union@Volume #Can compute exactly as well
