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

#plot.variogram can control x axis with xlim or fraction
plot(v,CTMM=m, xlim=c(0,2 %#% "hour"))
plot(vg,CTMM=mod,fraction=0.65)
plot(vg,CTMM=mod,fraction=1) #full variogram, but first 50% is generally helpful

#---- autocorrelation decay ----#
# From chris "tau_p = 6 days does not mean that the variogram asymptotes at 6 days. 
# This is an exponential decay timescale, and so for instance you get 95% decay at 3*tau_p"

# Also from chris:
# "tau_velocity is approximately the timescale over which correlations in velocity decay exponentially. 
# Velocity autocorrelation decays with an envelope like exp(-lag/tau_velocity). 
# So when only 5% of velocity autocorrelation is remaining you have 0.05=exp(-lag/tau_velocity) which 
# you can solve to find  lag=-log(0.05)*tau_velocity."

# so, if we have a given amount of autocorrelation we can solve for lag
# acor = exp(-lag/tau_v)
# log(acor) = -lag/tau_v
# lag = tau_v * -log(acor)

#also note that at the point lag = tau_v, we have:
# acor = exp(-tau_v/tau_v)
# acor = exp(-1)
# acor ~ 37%
# at lag = tau_v, we have 37% autocorrelation remaining
# and 100-37% = 63% decay in autocorrelation

#based on above, the exponential decay function is valid for both tau_v and tau_p

#when is velocity 95% uncorrelated?
#note that -log(0.05) is around 3
m$tau['velocity'] * -log(0.05) #note velocity is in SI units, so this is seconds
m$tau['velocity'] * -log(0.05)/60 #now this value is in minutes

#--- plotting ----#

#-- to add a vertical line to the plot, need to get the units of the x-axis
# The x-axis of the plot is dynamic. After plotting, can extract the units from the plot environment
# The units are given as number of seconds in each plot unit
# So, if plot is in hours x.scale will be 3600
# if plot is in days x.scale will be 86400
p95 <- mod$tau['position'] * -log(0.05) #this is in seconds
plot(vg,CTMM=mod, xlim=c(0,p95*1.5)) #x units will adjust automatically
abline(v=p95/get("x.scale",envir=ctmm:::plot.env),lty='dashed') #need to scale to plot units
title('95% decay in position autocorrelation')

ls(ctmm:::plot.env) #can see other items in plot env

#---- Evaluating model fit ----#

# From Chris: https://groups.google.com/forum/#!topic/ctmm-user/Blcg7gb-aAY
# "But also for this specific variogram, I would be careful to make sure that telemetry error or non-stationarity 
# aren't problematic because the fitted model is only nailing the first lag. The sampling rate seems to be ~5 minutes. 
# With larger species, the finer the sampling, the bigger problem unmodeled telemetry error becomes for underestimating 
# tau_velocity."

# In plot, semivariance of model is higher than empirical semi-variance for most of the plot
# So, this means an underestimate of tau_v results in overestimate of semi-variance
#---- ctmm objects ----#

#-- ctmm model
m$MSPE # "mean square predictive error" for model selection on trend terms.
m$tau #has tau velocity and tau position

#--- exporting ---#
SpatialPolygonsDataFrame.UD(akde, level.UD=0.95,level=0.95) #Convert UD to SPDF
