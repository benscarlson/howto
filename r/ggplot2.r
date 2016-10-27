
geom_text_repel(data=dat, aes(x=lon, y=lat,label=study_num),size=3,force=3) + #segment.color = NA (use this to turn off lines) 

#create a three part color gradient
scale_color_gradient2('Legend title',low="red", mid='green', high='blue',
  midpoint=median(x),
  breaks=c(1,2,3,4),
  labels=c('one','two','three','four'))
