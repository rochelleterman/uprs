rm(list=ls())
setwd("~/Dropbox/berkeley/Dissertation/Data and Analyais/Git Repos/uprs/upr-info/Analysis")

library(tm)
library(RTextTools) # a machine learning package for text classification written in R
library(SnowballC) # for stemming
library(matrixStats) # for statistics
library(irr) 

######################
#### Prepare Data ####
######################

documents <- read.csv('../Data/upr-info-binary.csv', stringsAsFactors = F)

# Prepare Corpus
docs <- Corpus(VectorSource(documents$Text))
docs

# Make DTM
dtm <- DocumentTermMatrix(docs,
                          control = list(weighting =function(x) weightTfIdf(x, normalize = TRUE),
                                         tolower = TRUE,
                                         stopwords = TRUE,
                                         removeNumbers = TRUE,
                                         removePunctuation = TRUE,
                                         stemming=TRUE))

dim(dtm)
# coerce into dataframe
dtm <- as.data.frame(as.matrix(dtm))

# add issue matrix
themes <- documents[,18:71]

###########################
#### Scoring Functions ####
###########################

# standardized mean difference
smd <- function(theme){
  # find index
  index.one <- which(themes[[theme]]==1 & rowSums(themes)==1)
  index.rest <- which(themes[[theme]]==0)
    
  # Subset into 2 dtms
  one <- dtm[index.one,] 
  rest <- dtm[index.rest,]
  
  # calculate means and vars
  means.one <- colMeans(one)
  var.one<- colVars(as.matrix(one))
  means.rest <- colMeans(rest)
  var.rest <- colVars(as.matrix(rest))

  #calculate overall score
  num <- (means.one - means.rest) 
  denom <- sqrt((var.one/3) + (var.rest/3))
  score <- num / denom
  
  # score
  score <- sort(score)
  score <- tail(score, 50)
  return(cbind(score))
  
  # sort and view
  return(cbind(score))
}

# standard log odds
log.odds <- function(theme){
  
  # find index
  index.one <- which(themes[[theme]]==1 & rowSums(themes)==1)
  index.rest <- which(themes[[theme]]==0)
  
  # Subset into 2 dtms
  one <- dtm[index.one,] 
  rest <- dtm[index.rest,]

  # calculate
  n.one <- sum(colSums(one))
  n.rest <- sum(colSums(rest))

  pi.one <- (colSums(one) + 1) / (n.one + ncol(one)-1)
  pi.rest <- (colSums(rest) + 1) / (n.rest + ncol(rest)-1)  

  log.odds.ratio <- log(pi.one/(1-pi.one)) - log(pi.rest / (1-pi.rest))
  st.log.odds <- log.odds.ratio/sqrt(var(log.odds.ratio))
  
  # sort
  score <- sort(st.log.odds)
  score <- tail(score, 50)
  return(cbind(score))
}

# difference in proportions
diff.prop <- function(theme){
 
  # find index
  index.one <- which(themes[[theme]]==1 & rowSums(themes)==1)
  index.rest <- which(themes[[theme]]==0)
  
  # Subset into 2 dtms
  one <- dtm[index.one,] 
  rest <- dtm[index.rest,]
  
  # calculate means and vars
  means.one <- colMeans(one)
  means.rest <- colMeans(rest)
  
  score <- unlist(means.one - means.rest)
  score <- sort(score)
  score <- tail(score, 50)
  return(cbind(score))
}

# scoring function 
score <- function(measure, data){
  
  # Score each document
  M <- data[,colnames(data) %in% rownames(measure)]
  y <- measure[,1]
  x <- apply(M, 1, function(x) sum(x * y))
  
  # put Scores in a data frame
  a <- as.data.frame(cbind(x))
  names(a) <- "Score"
  a$Score <- as.numeric(a$Score)
  
  return(a)
}


################################
##### Testing Classification ###
################################

# make a matrix
children <- log.odds("Rights.of.the.Child")
children <- smd("Rights.of.the.Child")
children[1:5]

# Score documents
a <- score(children, dtm)
a$True <- themes$Rights.of.the.Child

summary(a$Score[a$True == 1])
summary(a$Score[a$True == 0])

plot(True ~ Score, data = a)

# Predict
threshold = .3
t <- which(a$Score >= .3)
a$Predict <- NA
a$Predict[t] <- 1
a$Predict[-t] <- 0

###############################
##### Evaluation Metrics ######
###############################

# create kappa value
ratings <- a[,c(2,3)]
kappa2(ratings)

# % agree 
length(which(a$Predict == a$True)) / nrow(a) ## 0.9345687

# f-scores n such
retrieved <- sum(a$Predict)
precision <- sum(a$Predict & a$True) / retrieved
precision
recall <- sum(a$Predict & a$True) / sum(a$True)
recall
Fmeasure <- 2 * precision * recall / (precision + recall)
Fmeasure

####################
##### Amnesty ######
####################

# orig corpus
myCorpus <- corpus(documents$Text, docvars=documents[,-5])
myStemMat <- dfm(myCorpus, stopwords=TRUE, stem=TRUE, ignoredFeatures=stopwords("english"))
#x <- as.matrix(myStemMat)

# amnesty corpus
a <- read.csv("total_amnesty2.csv", stringsAsFactors = F)
a <- a[!is.na(a$teaser),]

# make dtm
a.c <- corpus(a$teaser)
a.c <- dfm(a.c, stopwords=TRUE, stem=TRUE, ignoredFeatures=stopwords("english"))
ac2 <- selectFeatures(a.c, features(myStemMat))

acm <- as.matrix(ac2)
acm <- as.data.frame(ac2)

x <- score(children, acm)
x$keywords <- a$keywords
x$text <-a$teaser
