rm(list=ls())
setwd("~/Dropbox/berkeley/Dissertation/Data and Analyais/Git Repos/uprs/Analysis/text-analysis")

library(plyr)
library(RTextTools)
library(qdap)
library(stringr)
library(mallet)
library(tm)

######################
#### Prepare Data ####
######################

#read in CSV file
docs <- read.csv('~/Dropbox/berkeley/Dissertation/Data and Analyais/Git Repos/uprs/Data/all-data-cown.csv', stringsAsFactors = F)

#make dtm
dtm <- create_matrix(docs$text, language="english", removeNumbers=TRUE,
                     stemWords=TRUE, toLower = TRUE, removePunctuation = TRUE, 
                     removeStopwords = TRUE, removeSparseTerms= .995 )
dim(dtm)

#####################
#### explore DTM ####
#####################

# order
freq <- colSums(as.matrix(dtm))
ord <- order(freq)
# Least frequent terms
freq[head(ord)]
# most frequent
freq[tail(ord)]
# frequency of frenquencies
head(table(freq),15)
tail(table(freq),15)
plot(table(freq))

# Have a look at common words
findFreqTerms(dtm, lowfreq=100) # words that appear at least 100 times

# Which words correlate with "war"?
findAssocs(dtm, "war", 0.3)

#############
#### PCA ####
#############

pr <- prcomp(dtm,scale=TRUE)
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


####################
#### K- Means ####
####################

set.seed(1234)
n = 20
clust <- kmeans(recs,n, nstart= 25)
centers <- as.data.frame(clust$centers) #make dataframe of cluster centers

# write a function that inputs cluser number k (e.g. k = 2) outputs the top 10 words as per the definition given
top10words <- function(k){
  theta.k <- centers[k,] # define theta-k, i.e.  row k of cluster centers dataframe
  theta.notk <- colSums(centers[-(k),])/5 # define theta-not-k, i.e. rows not-k of cluster centers divided by 5 (number of clusters - 1)
  diffk <- as.data.frame(theta.k - theta.notk) # define difference diffk
  return(colnames(diffk[,order(diffk,decreasing=TRUE)][1:10])) # order decreasing, take top 10
}
keywords<- matrix(NA, nrow=10, ncol=6) # set up a matrix to contain data
for (i in 1:6){
  keywords[,i] <- top10words(i)
}
colnames(keywords) <- c("cluster 1","cluster 2","cluster 3","cluster 4","cluster 5","cluster 6")
keywords

