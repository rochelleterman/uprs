library(quanteda)

rm(list=ls())
setwd("~/Dropbox/berkeley/Git-Repos/uprs/v.2/Predict-Categories")

documents <- read.csv('../Data/upr-info-binary.csv', stringsAsFactors = F)
documents <- documents[,c(1,2,4,8,11,18:71)]
names(documents)

# Prepare Data
myCorpus <- corpus(documents$Text, docvars=documents[,-5])
myStemMat <- dfm(myCorpus, stopwords=TRUE, stem=TRUE, ignoredFeatures=stopwords("english"))
#x <- as.matrix(myStemMat)

corp.train <- myStemMat[1:30000,]
corp.test <- myStemMat[30001:41066,]

children <- documents$Rights.of.the.Child
children[children==0] <- -1

# Train model
ws <- textmodel_wordscores(corp.train, children[1:30000])
words <- ws@Sw
head(sort(words, decreasing = T), 50)

# Score documents
x <- predict(ws, newdata = corp.test, rescaling="lbg")
test <- x@textscores
test$True <- documents$Rights.of.the.Child[30001:41066]
names(test)[5] <- "Score"
summary(test$Score[test$True==1])
summary(test$Score[test$True==0])
plot(True ~ Score, data = test)

# Predict
threshold <- 0
predictedTrue <- which(test$Score>threshold)
test$Predict <- NA
test$Predict[predictedTrue] <- 1
test$Predict[-predictedTrue] <- 0

# Test
library(irr)
ratings <- test[,c("True","Predict")]
kappa2(ratings)

length(which(test$Predict == test$True)) / nrow(test) ## 0.9362913

retrieved <- sum(test$Predict)
precision <- sum(test$Predict & test$True) / retrieved
precision
recall <- sum(test$Predict & test$True) / sum(test$True)
recall
Fmeasure <- 2 * precision * recall / (precision + recall)
Fmeasure

## Trying on Amnesty subset

a <- read.csv("total_amnesty2.csv", stringsAsFactors = F)
a <- a[!is.na(a$teaser),]

# Make DTM

a.c <- corpus(a$teaser)
a.c <- dfm(a.c, stopwords=TRUE, stem=TRUE, ignoredFeatures=stopwords("english"))
ac2 <- selectFeatures(a.c, features(myStemMat))

x <- predict(ws, newdata = ac2, rescaling = "lbg")
a.t <- x@textscores

a.t$keywords <- a$keywords
a.t$text <-a$teaser
