
grid.arrange(p1,p2,p3,ncol=3)

pdf("filename.pdf")
grid.arrange( graph1, graph2, ncol=2)
dev.off()
