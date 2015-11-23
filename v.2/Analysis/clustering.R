# CLUSTERING

rm(list=ls())
setwd("~/Dropbox/berkeley/Git-Repos/uprs/v.2/Analysis")

library(corrgram)
library(pvclust)
library(countrycode)
library(lsa)
library('dendextend')
library('dendextendRcpp')
library(ggplot2)
library(readstata13)
library(plyr)

######################
#### Prepare Data ####
######################

#documents <- read.csv('../Data/upr-info-binary.csv', stringsAsFactors = F)
load("Data/datasets.RData")
load("Data/sender-100.RData")

#############################
#### Clustering - theme ###
#############################

# http://research.stowers-institute.org/mcm/efg/R/Visualization/cor-cluster/index.htm
data <- themes[,which(colSums(themes)>50)]

# removing irrelevant themes
data$International.instruments <- NULL
data$General <- NULL
data$International.humanitarian.law <- NULL
data$NHRI <- NULL
data$Special.procedures <- NULL
data$UPR.process <- NULL
data$Technical.assistance.and.cooperation <- NULL
data$Treaty.bodies <- NULL
data$National.plan.of.action <- NULL
data$Other <- NULL
data$Human.rights.education.and.training <- NULL
data$CP.rights...general <- NULL
data$ESC.rights...general <- NULL

# correlations
correlations <- as.data.frame(cor(data))
#corrgram(correlations)
dissimilarity <- 1 - cor(data)
dissimilarity
distance <- as.dist(dissimilarity)
round(distance, 4) 

# Create a dend
dend <- distance %>% hclust(method="mcquitty") %>% as.dendrogram

# and plot it:
par(mar=c(3,3,2,14))

dend %>% 
  set("labels_col", value = c("maroon2","red","orange","olivedrab3","olivedrab3","olivedrab3","steelblue2","steelblue2","royalblue4","purple","purple", "maroon2", "maroon2","red","red"), k=15) %>% 
  set("branches_k_color") %>% 
  set("labels_cex", .8) %>% 
  #hang.dendrogram %>% # hang the leaves
  plot(horiz=T)

# Assigning groups
dend %>% labels
traffchildwomen <- labels(dend)[2:4]
physint <- labels(dend)[c(1,5:10)]
justice <- labels(dend)[11:14]
political <- labels(dend)[15:20]
discrimination <- labels(dend)[21:23]
migrants <- labels(dend)[24:28]
socio.econ <- labels(dend)[29:38]
voln.populations <- labels(dend)[39:41]

# write function to get number of recs per cluster
get.cluster.n <- function(cluster){
  # subset recs with only columsn in cluster
  y <- recs[,colnames(recs) %in% cluster]
  
  # subset recs with at least 1 theme in cluster
  y.yes <- y[rowSums(y) > 0,]
  
  return(nrow(y.yes))
}
get.cluster.n(voln.populations)

# make data frame of cluster - n values
cluster <- c('traffchildwomen','physint','justice','political','discrimination','migrants','socio.econ','voln.populations')
counts <- c(get.cluster.n(traffchildwomen),
            get.cluster.n(physint),
            get.cluster.n(justice),
            get.cluster.n(political),
            get.cluster.n(discrimination),
            get.cluster.n(migrants),
            get.cluster.n(socio.econ),
            get.cluster.n(voln.populations)
)
n.cluster <- data.frame(cluster,counts)
n.cluster$proportions <- n.cluster$count/nrow(recs)
n.cluster$cluster <- ordered(n.cluster$cluster, levels = n.cluster$cluster)
n.cluster

sum(n.cluster$proportions)

# save it
write.csv(n.cluster,"Results/Clustering/recs-per-cluster.csv")

# plot it
n.cluster  %>%
  ggplot (aes(cluster, proportions, fill=cluster)) +
  geom_bar (stat ="identity") +
  theme(axis.text.x=element_text(angle=45,hjust=1)) +
  ggtitle("Proportion of Recommendations Per Cluster")

# ADD BINARY COLUMNS INDICATING CLUSTER

binary <- function(cluster){
  # subset recs with only columns in cluster
  y <- recs[,colnames(recs) %in% cluster]
  
  # get index of recs with at least 1 theme in cluster
  return(which(rowSums(y) > 0))
}

documents$traffchildwomen <- 0
documents$traffchildwomen[binary(traffchildwomen)] <- 1

documents$physint <- 0
documents$physint[binary(physint)] <- 1

documents$justice <- 0
documents$justice[binary(justice)] <- 1

documents$political <- 0
documents$political[binary(political)] <- 1

documents$discrimination <- 0
documents$discrimination[binary(discrimination)] <- 1

documents$migrants <- 0
documents$migrants[binary(migrants)] <- 1

documents$socio.econ <- 0
documents$socio.econ[binary(socio.econ)] <- 1

documents$voln.populations <- 0
documents$voln.populations[binary(voln.populations)] <- 1

sum(documents$voln.populations)

write.csv(documents, "../Data/upr-info-clusters.csv")

#############################################
#### Clustering - Themes based on Reports ###
#############################################

data <- reports[,which(colSums(reports)>50)]
# removing irrelevant themes
data$International.instruments <- NULL
data$General <- NULL
data$International.humanitarian.law <- NULL
data$NHRI <- NULL
data$Special.procedures <- NULL
data$UPR.process <- NULL
data$Technical.assistance.and.cooperation <- NULL
data$Treaty.bodies <- NULL
data$National.plan.of.action <- NULL
data$Other <- NULL
data$Human.rights.education.and.training <- NULL
data$CP.rights...general <- NULL
data$ESC.rights...general <- NULL

### CORRELATIONS

correlations <- as.data.frame(cor(data))
dissimilarity <- 1 - cor(data)
dissimilarity
d <- as.dist(dissimilarity)
round(d, 4) 

# Create a dend:
dend <- d %>% hclust(method ="mcquitty") %>% as.dendrogram

# and plot it:
par(mar=c(8,5,2,2))

dend %>% 
  set("labels_col") %>% 
  set("branches_k_color") %>% 
  set("labels_cex", .5) %>% 
  plot
dend %>% rect.dendrogram(k=2, border = 8, lty = 5, lwd = 2)

## COSINE

d <- cosine(as.matrix(data))
d <- as.dist(1-d) 
d

# Create a dend:
dend <- d %>% hclust %>% as.dendrogram

# and plot it:
dend %>% 
  set("labels_col", k=10) %>% 
  set("branches_k_color", k=10) %>% 
  set("labels_cex", .5) %>% 
  plot
dend %>% rect.dendrogram(k=2, border = 8, lty = 5, lwd = 2)

##############################
#### Clustering - Sender ###
##############################

# correlations
data = sender.100
data$International.instruments <- NULL
data$General <- NULL
data$International.humanitarian.law <- NULL
data$NHRI <- NULL
data$Special.procedures <- NULL
data$UPR.process <- NULL
data$Technical.assistance.and.cooperation <- NULL
data$Treaty.bodies <- NULL
data$National.plan.of.action <- NULL
data$Other <- NULL
data$Human.rights.education.and.training <- NULL

data = as.data.frame(t(data))
correlations <- as.data.frame(cor(data))
# corrgram(correlations)

dissimilarity <- 1 - cor(data)
d <- as.dist(dissimilarity)
round(d, 4) 

# euclidean distance
data <- sender.100
d <- dist(data,method="euclidean")
d

# cosign
data = (sender.100)
data$International.instruments <- NULL
data$General <- NULL
data$International.humanitarian.law <- NULL
data$NHRI <- NULL
data$Special.procedures <- NULL
data$UPR.process <- NULL
data$Technical.assistance.and.cooperation <- NULL
data$Treaty.bodies <- NULL
data$National.plan.of.action <- NULL
data$Other <- NULL
data$Human.rights.education.and.training <- NULL

data <- as.data.frame(t(data))

d <- cosine(as.matrix(data))
d <- as.dist(1-d) 
d
#plot(hclust(d), main = "Dissimilarity = 1 - Cosine")

# Create a dend:
dend <- d %>% hclust %>% as.dendrogram

# and plot it:
dend %>% 
  set("labels_col") %>% 
  set("branches_k_color") %>% 
  set("labels_cex", .8) %>% 
  hang.dendrogram %>% # hang the leaves
  plot(horiz=T)
dend %>% rect.dendrogram(k=5, border = 8, lty = 5, lwd = 2)


###################################
#### Factor Analysis on Sender ####
###################################

# Maximum Likelihood Factor Analysis
# entering raw data and extracting 3 factors, 
# with varimax rotation 
fit <- factanal(sender.100, 2, rotation="varimax", scores="regression" )
print(fit, digits=2, cutoff=.3, sort=TRUE)

# plot factor 1 by factor 2 
load <- fit$loadings[,1:2] 
plot(load,type="n") # set up plot 
text(load,labels=names(sender.100),cex=.7) # add variable names

load <- fit$scores
plot(load,type="n") # set up plot 
text(load,labels=row.names(sender.100),cex=.7) # add variable names

# determine n factor
library(nFactors)
ev <- eigen(cor(sender.100)) # get eigenvalues
ap <- parallel(subject=nrow(sender.100),var=ncol(sender.100),
               rep=100,cent=.05)
nS <- nScree(x=ev$values, aparallel=ap$eigen$qevpea)
plotnScree(nS)
