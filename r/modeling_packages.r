#---- glmmTMB ----#

summary(m)
confint(m)

names(ranef(m))
str(ranef(m))

str(ranef(m)$cond) #individual model parameters are in cond slot

slopes <- ranef(m)$cond$niche_name %>%
  rownames_to_column(var='niche_name')

ggplot(slopes,aes(x=niche_name,y=tree)) +
  geom_point()
