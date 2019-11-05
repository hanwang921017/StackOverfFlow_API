#R code to build the social network, the giant network component and the 3D plots of the two networks

# clear the workspace
rm(list=ls())
# library
library(sna)
library(igraph)
#import data
QA <- read.csv('allPosts.csv',
               header=TRUE, row.names=1, check.names=FALSE, na.strings = "")
asker<-QA[['AskerId']]
answerer<-QA[['AnswererId']]
# create links
links <- data.frame(
  source=asker,
  target=answerer)
# Turn it into igraph object
network <- graph_from_data_frame(d=links, directed=T) 
# Count the number of degree for each node:
deg <- degree(network, mode="all")
# Plot
plot(network, vertex.size=deg*1.5,vertex.label.cex=0.3,edge.arrow.size=0.2,
     layout=layout.fruchterman.reingold, main="fruchterman.reingold")
#Title
text(0,-1.5,"StackOverFlow Social Network Tagged Python",col="red", cex=1.5)

##########################
#extract component
library(CINNA)
com<-giant_component_extract(network, directed = TRUE, bipartite_proj = FALSE,num_proj = 1)
asker_com<-com[2][[1]][,1]
answerer_com<-com[2][[1]][,2]
links <- data.frame(
  source=com[2][[1]][,1],
  target=com[2][[1]][,2])
# Turn it into igraph object
network_com <- graph_from_data_frame(d=links, directed=T) 
# Count the number of degree for each node:
deg <- degree(network, mode="all")
# Plot
plot(network_com, vertex.size=deg*1.5,vertex.label.cex=0.3,edge.arrow.size=0.2,
     layout=layout.fruchterman.reingold, main="fruchterman.reingold")
#Title
text(0,-1.5,"StackOverFlow Social Network Component",col="red", cex=1.5)

##########################
#3D plot
library(igraph)
library(networkD3)
# create a dataset

data_total <- data.frame(from=asker,to=answerer)
data_com <- data.frame(from=asker_com,to=answerer_com)
# Plot
p1 <- simpleNetwork(data_total,height="100px", width="100px")
print(p1)
p2 <- simpleNetwork(data_com,height="100px", width="100px")
print(p2)
############################
# save the component data to computer
write.csv(data_com,file="/Users/hanwang/Documents/ECE720X01/Assignments/A1/data_com.csv",quote=F,row.names = F)
