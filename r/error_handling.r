#If an error might be encountered while doing lapply, use tryCatch and return NULL
#Then, filter out NULL entries from the list
hvList<-lapply(file.path(hvP,'hvs',glue('{nicheSet$niche_name}.rds')), 
                 function(x) tryCatch(readRDS(x),error=function(e) NULL))
hvList <- hvList[lengths(hvList) != 0] #https://stackoverflow.com/questions/33004238/r-removing-null-elements-from-a-list

#return from try() when error is object of class 'try-error'
#can check for existence of this object then act accordingly.

hv <- try(hypervolume_gaussian(data=datHv,name=niche$niche_name))

if(class(hv)=='try-error') {
  message('error')
} else {
  #do what you want
}
 
