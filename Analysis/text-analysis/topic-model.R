rm(list=ls())
setwd("~/Dropbox/berkeley/Dissertation/Data and Analyais/Git Repos/uprs/Analysis/text-analysis")

library(plyr)
library(RTextTools)
library(qdap)
library(stringr)
library(mallet)

# prepare stopwords list

#read in CSV file
documents <- read.csv('~/Dropbox/berkeley/Dissertation/Data and Analyais/Git Repos/uprs/Data/all-data-cown.csv', stringsAsFactors = F)
names(documents)

# rewrite 'id' column
documents$id <- rownames(documents)

# remove punctuation
documents$text <- gsub(pattern="[[:punct:]]",replacement=" ",documents$text)

# load data into mallet
mallet.instances <- mallet.import(documents$id, documents$text, "Data/text-tools/stoplist_countries.csv", FALSE, token.regexp="[\\p{L}']+")

## Create a topic trainer object.
topic.model <- MalletLDA(num.topics=20)

## Load our documents
topic.model$loadDocuments(mallet.instances)

## Get the vocabulary, and some statistics about word frequencies.
##  These may be useful in further curating the stopword list.
vocabulary <- topic.model$getVocabulary()
word.freqs <- mallet.word.freqs(topic.model)

# examine some of the vocabulary
word.freqs[1:50,]

## Optimize hyperparameters every 20 iterations, 
##  after 50 burn-in iterations.
topic.model$setAlphaOptimization(20, 50)

## Now train a model. Note that hyperparameter optimization is on, by default.
##  We can specify the number of iterations. Here we'll use a large-ish round number.
topic.model$train(200)

## NEW: run through a few iterations where we pick the best topic for each token, 
##  rather than sampling from the posterior distribution.
topic.model$maximize(10)

## Get the probability of topics in documents and the probability of words in topics.
## By default, these functions return raw word counts. Here we want probabilities, 
##  so we normalize, and add "smoothing" so that nothing has exactly 0 probability.
doc.topics <- mallet.doc.topics(topic.model, smoothed=T, normalized=T)
topic.words <- mallet.topic.words(topic.model, smoothed=T, normalized=T)

## What are the top words in topic X?
## Notice that R indexes from 1, so we have to look for row X+1.
mallet.top.words(topic.model, topic.words[3,])

# take a quick look at the top words of each topic
topic.labels <- mallet.topic.labels(topic.model, topic.words, num.top.words = 10)
topic.labels

## Get a vector containing short names for the topics
n.topics <- 20
topics.labels <- rep("", n.topics)
for (topic in 1:n.topics) 
  topics.labels[topic] <- paste(mallet.top.words(topic.model, topic.words[topic,], num.top.words=10)$words, collapse=" ")

# have a look at keywords for each topic
topics.labels
write.csv(topics.labels,"20-topics-labels.csv")

## Show the first few document titles with at least .5 of its content devoted to topic 4
head(documents[ doc.topics[4,] > 0.5 , ],10)

## Show title of the most representative text for topic 4
documents[which.max(doc.topics[4,]),]$text

# plot clusters
topics.labels
plot(mallet.topic.hclust(doc.topics, topic.words, 0), labels=topics.labels)

