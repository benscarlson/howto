#----
#---- migrateR
#----

dat <- dat0 %>% as.data.frame

mods <- as.ltraj( #Create ltraj object
    xy=dat %>% select(lon,lat), 
    date=dat$timestamp, 
    id=dat$individual_id) %>% 
  mvmtClass #Run the migration model

mvmt2dt(mods) #modeled start and end dates of migratory movements
