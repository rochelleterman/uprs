rm(list=ls())
setwd("~/Dropbox/berkeley/Dissertation/Data and Analyais/Git Repos/uprs/Analysis/text-analysis")

library(plyr)
library(RTextTools)
library(qdap)
library(stringr)
library(mallet)
library(corrgram)

######################
#### Prepare Data ####
######################

documents <- read.csv('~/Dropbox/berkeley/Dissertation/Data and Analyais/Git Repos/uprs/Data/all-cown-binary.csv', stringsAsFactors = F)
names(documents)

# make codes for country labels
codes <- data.frame(cbind(documents$to,documents$to_COW,documents$year))
codes <- unique(codes)
names(codes) <- c("to","COW","year")
codes <- arrange(codes,to,year)

# reshape by report
recs <- documents[,c(2,6,79:131)] #just take themes, country, year
reports <- ddply(.data=recs, .variables=.(to,year), numcolwise(sum,na.rm = TRUE))
reports <- reports[3:55]

# just take themes in recs
recs <- recs[,c(3:55)]

# transpose recs to clustering themes by text
recs.t <- data.frame(t(recs))

#####################
#### Correlations ###
#####################

# http://research.stowers-institute.org/mcm/efg/R/Visualization/cor-cluster/index.htm

data = recs

correlations <- as.data.frame(cor(data))
x <- arrange(correlations,terrorism)
corrgram(correlations)

documents$text[documents$property==1]

dissimilarity <- 1 - cor(data)
distance <- as.dist(dissimilarity)
round(distance, 4) 

plot(hclust(distance), 
  main="Dissimilarity = 1 - Correlation", xlab="")

library(pvclust)
cluster.bootstrap <- pvclust(correlations, nboot=1000, method.dist="abscor")
plot(cluster.bootstrap)
pvrect(cluster.bootstrap)

#################
#### K-Means ####
#################

# this doesn't work all that well.

data = reports

set.seed(1234)
n = 20
clust <- kmeans(data,n, nstart= 25)
centers <- as.data.frame(clust$centers) #make dataframe of cluster centers

# only when clusterings on texts or reports
top5themes <- function(k){
  theta.k <- centers[k,] # define theta-k, i.e.  row k of cluster centers dataframe
  theta.notk <- colSums(centers[-(k),])/5 # define theta-not-k, i.e. rows not-k of cluster centers divided by 5 (number of clusters - 1)
  diffk <- as.data.frame(theta.k - theta.notk) # define difference diffk
  return(colnames(diffk[,order(diffk,decreasing=TRUE)][1:5])) # order decreasing, take top 10
}
keywords<- matrix(NA, nrow=5, ncol=n) # set up a matrix to contain data
for (i in 1:n){
  keywords[,i] <- top5themes(i)
}
keywords

# see which theme is in which cluster
clusters <- as.data.frame(clust$cluster)
clusters$theme <- rownames(clusters)
colnames(clusters) <- c("cluster","theme")
clusters$cluster <- as.factor(clusters$cluster)
clusters <- arrange(clusters,cluster)

# hclust on reports
distance.matrix <- dist(reports, method = "euclidean", diag = FALSE, upper = FALSE, p = 2)
x<- hclust(distance.matrix, method = "complete", members = NULL)
plot(x)

###########
### pca ###
###########

data = recs

pr <- prcomp(data)
plot(pr,type="l",main="Number of Components v. Variance Explained")

library(ggplot2)
scores = as.data.frame(pr$x)
ggplot(data = scores, aes(x = PC1, y = PC2, label = rownames(scores))) +
  geom_hline(yintercept = 0, colour = "gray65") +
  geom_vline(xintercept = 0, colour = "gray65") +
  geom_text(colour = "blue", alpha = 0.8, size = 4) +
  ggtitle("PCA Plot")

rotation <- as.data.frame(pr$rotation)
ggplot(data = rotation, aes(x = PC1, y = PC2, label = rownames(rotation))) +
  geom_hline(yintercept = 0, colour = "gray65") +
  geom_vline(xintercept = 0, colour = "gray65") +
  geom_text(colour = "red", alpha = 0.8, size = 4) +
  ggtitle("PCA Rotation Plot")


#######################
### factor analysis ###
#######################

fit <- factanal(data, 6, rotation="varimax")
print(fit, digits=2, cutoff=.3, sort=TRUE)
# plot factor 1 by factor 2 
load <- fit$loadings[,1:2] 
plot(load,type="n") # set up plot 
text(load,labels=names(data),cex=.7) # add variable names

# Determine Number of Factors to Extract
library(nFactors)
ev <- eigen(cor(data)) # get eigenvalues
ap <- parallel(subject=nrow(data),var=ncol(data),
               rep=100,cent=.05)
nS <- nScree(x=ev$values, aparallel=ap$eigen$qevpea)
plotnScree(nS)
