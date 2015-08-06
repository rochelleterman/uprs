rm(list=ls())
setwd("~/Dropbox/berkeley/Dissertation/Data and Analyais/Git Repos/uprs/Analysis/clustering-and-text")

library(plyr)
library(RTextTools)
library(qdap)
library(stringr)
library(mallet)
library(corrgram)
library(pvclust)
library(countrycode)
library(matrixStats)
library(lsa)

######################
#### Prepare Data ####
######################

documents <- read.csv('~/Dropbox/berkeley/Dissertation/Data and Analyais/Git Repos/uprs/Data/all-cown-binary.csv', stringsAsFactors = F)
names(documents)

# make codes for country labels
documents$to_COW <- countrycode(documents$to_COW, "cown", "cowc")
documents$from_COW <- countrycode(documents$from_COW, "cown", "cowc")

# subset
recs <- documents[,c(3,5,6,79:131)] # just keep to, from, year, themes

# report as UOA
temp = recs[,c(1,3:56)]
reports <- ddply(.data=temp, .variables=.(to_COW,year), numcolwise(sum,na.rm = TRUE))
row.names(reports) <- paste(reports$to_COW,reports$year,sep="-")
reports <- reports[,-c(1,2)]

# themes as UOA
names(recs)
themes <- recs[,c(4:56)]
themes.t <- data.frame(t(themes))

# sender as UOA
temp <- recs[,c(2,4:56)]
sender <- ddply(.data=temp, .variables=.(from_COW), numcolwise(sum,na.rm = TRUE))
sender$from_COW[is.na(sender$from_COW)] <- "PLST"
row.names(sender) <- sender$from_COW
sender$from_COW <- NULL

sender <- sender[rowSums(sender) > 100,] # keep only those who give at least 100 recs

# transpose recs to clustering themes by text
#recs.t <- data.frame(t(recs))

#############################
#### Clustering - theme ###
#############################

# http://research.stowers-institute.org/mcm/efg/R/Visualization/cor-cluster/index.htm

# correlations
data <- themes

correlations <- as.data.frame(cor(data))
corrgram(correlations)

dissimilarity <- 1 - cor(data)
distance <- as.dist(dissimilarity)
round(distance, 4) 

plot(hclust(distance), 
  main="Dissimilarity = 1 - Correlation", xlab="")

##############################
#### Clustering - Sender ###
##############################

# correlations
data = as.data.frame(t(sender))

correlations <- as.data.frame(cor(data))
# corrgram(correlations)

dissimilarity <- 1 - cor(data)
distance <- as.dist(dissimilarity)
round(distance, 4) 

plot(hclust(distance), 
     main="Dissimilarity = 1 - Correlation", xlab="")

# euclidean distance
data <- sender
d <- dist(data,method="euclidean")
plot(hclust(d), main="Dissimilarity = Euclid", xlab="")

# cosign
data = as.data.frame(t(sender))

d <- cosine(as.matrix(data))
d <- as.dist(1-d) 
plot(hclust(d), main = "Dissimilarity = 1 - Cosine")

#cluster.bootstrap <- pvclust(correlations, nboot=1000, method.dist="abscor")
#plot(cluster.bootstrap)
#pvrect(cluster.bootstrap)


