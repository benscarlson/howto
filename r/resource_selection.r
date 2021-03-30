
#---------------------#
#---- Muff et al. ----#
#---------------------#

#Model requires stratum_id. 
#Amt provides step_id_ that identifies each step and all the potential background steps associated with that step
#But model requires stratum id that is unique across all animals
#This can be created by combining the id or name of the animal with the stratum.

mutate(stratum_id=paste(niche_name,step_id_,sep='_'))
    
