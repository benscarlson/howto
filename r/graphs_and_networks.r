
#https://www.jessesadler.com/post/network-analysis-with-r/
#network and igraph packages have a lot of overlaping capabilities. only have one loaded.
#tidygraph and ggraph new packages that use tidy workflow to do graph analysis

#---- tidygraph ----#

#-- create a tidygraph object

# Fully connected graph of three nodes
nodes <- tibble(id=1:3,label=paste('n',1:3,sep=''))

edges <- rbind(c(1,2),c(1,3),c(2,3)) %>% 
  as_tibble %>%
  rename(from=V1,to=V2)

net <- tbl_graph(nodes = nodes, edges = edges, directed = FALSE)

# tbl_graph object is also an igraph object, so can use directly in any igraph function

transitivity(net,type='global')

#---- ggraph ----#

ggraph(net) + geom_edge_link() + geom_node_point() + theme_graph()

ggraph(net, layout = "graphopt") + 
  geom_edge_link() +
  scale_edge_width(range = c(0.2, 2)) +
  geom_node_point(size=10,shape=21,fill='white') +
  geom_node_text(aes(label = label)) +
  labs(edge_width = "Overlap") +
  theme_graph()

#Add lables and weights to edges:
  geom_edge_link(aes(width = weight, label = weight), 
    angle_calc='along', label_dodge=unit(2.5,'mm'), alpha = 0.8)
