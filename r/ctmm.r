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

#To plot a model, need to plot a variogram
t <- telemetry object
v <- variogram(t)
m <- ctmm model

plot(v,CTMM=m, xlim=c(0,2 %#% "hour"))

#when is velocity 95% uncorrelated?
#note that -log(0.05) is around 3
m$tau['velocity'] * -log(0.05) #note velocity is in SI units, so this is seconds
m$tau['velocity'] * -log(0.05)/60 #now this value is in minutes

#---- ctmm objects ----#

#-- ctmm model
m$MSPE # "mean square predictive error" for model selection on trend terms.
m$tau #has tau velocity and tau position
