#convert dataframe to telemetry object
dat0 %>%
  filter(niche_name=='Magnus-2014') %>%
  arrange(timestamp) %>%
  select(location.long=lon,location.lat=lat,timestamp,individual.local.identifier=niche_name) %>%
  as.data.frame %>%
  as.telemetry()

#general workflow
tel <- as.telemetry()
vg <- variogram(tel)
GUESS <- variogram.fit(vg,interactive=FALSE)
ctmm.select(tel, CTMM=GUESS)

#AKDE
#akde can take a telemetry object and best.fit? Maybe this will internally fit model?
AKDES <- akde(telem.obj, best.fit)
#can also do like this, giving it a fitted model:
animal.akde <- akde(tel, mod, res = 50)
#also seems akde can take a list of objects and not just one at a time
#https://groups.google.com/d/msg/ctmm-user/_gMRESokCYc/MY9ShphIBwAJ
#might be required if I'm doing overlap metrics
