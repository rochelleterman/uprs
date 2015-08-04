rm(list=ls())
setwd("~/Dropbox/berkeley/Dissertation/Data and Analyais/Git Repos/uprs/Analysis/text-analysis")

library(plyr)
library(RTextTools)
library(qdap)
library(stringr)
library(mallet)

# prepare stopwords list

#read in CSV file
docs <- read.csv('~/Dropbox/berkeley/Dissertation/Data and Analyais/Git Repos/uprs/Data/all-data-cown.csv', stringsAsFactors = F)

dtm <- create_matrix(docs$text, language="english", removeNumbers=TRUE,
                     stemWords=TRUE, toLower = TRUE, removePunctuation = TRUE, 
                     removeSparseTerms = .97)

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
