
grid.arrange(p1,p2,p3,ncol=3)



#---- saving plots ----
# grid.arrange draws directly to the device. http://stackoverflow.com/questions/17059099/saving-grid-arrange-plot-to-file
# arrangeGrob returns a grob object which can be saved using ggsave
arrangeGrob(p1,p2,ncol=2)
ggsave(file="whatever.pdf", g)

# can also do the traditional way
pdf("filename.pdf")
  grid.arrange( graph1, graph2, ncol=2)
dev.off()
