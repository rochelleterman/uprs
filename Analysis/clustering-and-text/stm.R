rm(list=ls())
setwd("~/Dropbox/berkeley/Dissertation/Data and Analyais/Git Repos/uprs/Analysis/text-analysis")
library(stm)
library(plyr)

######################
#### Prepare Data ####
######################

documents <- read.csv('~/Dropbox/berkeley/Dissertation/Data and Analyais/Git Repos/uprs/Data/all-data-cown.csv', stringsAsFactors = F)
names(documents)
x <- sample(1:39329,10000)
docs <- documents[1:10000,c(1,3,4,5,7,9,11)]

# custom stopwords
countries <- read.csv("~/Dropbox/berkeley/Dissertation/Data and Analyais/Git Repos/uprs/Data/text-tools/stoplist_countries.csv",header=F)
names(countries)
stopwords.country <- as.character(countries$V1)

# process
temp<-textProcessor(documents=docs$text,metadata=docs,customstopwords=stopwords.country)
meta<-temp$meta
vocab<-temp$vocab
docs<-temp$documents
out <- prepDocuments(docs, vocab, meta, lower.thresh=20)
docs<-out$documents
vocab<-out$vocab
meta <-out$meta

meta$to_COW <- as.factor(meta$to_COW)
levels(meta$to_COW)

##################################
######### Choose Model ###########
##################################

### Set K = 30
model <- stm(docs,vocab, 30, prevalence=~to_COW, data=meta, seed = 00001, max.em.its=30, init.type="Spectral")
labelTopics(model)

save(model,file="30stmmodel.RD")

cormat <- topicCorr(model)
plot(cormat)

# Topic Quality plot
topicQuality(model, documents=docs)

# Topic Labels plot
plot.STM(model,type="labels",topics=1:10,width=75)
plot.STM(model,type="labels",topics=11:20,width=75)
plot.STM(model,type="labels",topics=21:30,width=75)
