#---- grid ----
rect <- rectGrob(gp = gpar(fill = "#00000080")) #make a rectable grob
tab <- gtable(unit(rep(1, 3), "null"), unit(rep(1, 3), "null")) #3x3 grid
#t = 1 is top row; l=1 start at first col; r=3 span to third col
tab1 <- gtable_add_grob(tab, rect, t = 1, l = 1, r = 3)
grid.newpage()
grid.draw(tab1)
#t = 1 is top row; l=1 start at first col; r=2 span to second col
tab1 <- gtable_add_grob(tab, rect, t = 1, l = 1, r = 2)
grid.newpage()
grid.draw(tab1)

#---- gtable ----
gtable_add_rows() #part of gtable package

#---- draw to device ----
grid.arrange(p1,p2,p3,ncol=3)
grid.arrange(grobs=<listofgrobs>,ncol=3) #a list of grobs or gtables

grid.newpage()
grid.draw(mygrob)

#---- saving plots ----
# grid.arrange draws directly to the device. http://stackoverflow.com/questions/17059099/saving-grid-arrange-plot-to-file
# arrangeGrob returns a grob object which can be saved using ggsave
g <- arrangeGrob(p1,p2,ncol=2)
ggsave(file="whatever.pdf", g)

# can also do the traditional way
pdf("filename.pdf")
  grid.arrange( graph1, graph2, ncol=2)
dev.off()

gtable_add_rows() #part of gtable package


#---- viewports ----
formatVPTree(current.vpTree()) #see the list of viewports. the one with all the stuff seems to be 'panel.6-4-6-4'
seekViewport('panel.6-4-6-4') #make this the current viewport (required to use grid.locator())
