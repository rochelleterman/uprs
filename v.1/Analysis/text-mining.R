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

