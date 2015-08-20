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

# take out voluntary pledges
documents <- documents[!documents$Response=="Voluntary Pledge",]

# should be 41066
nrow(documents)

# Prepare Corpus
docs <- Corpus(VectorSource(documents$Text))
docs

# Make DTM
dtm <- DocumentTermMatrix(docs,
                          control = list(tolower = TRUE,
                                         stopwords = T,
                                         removeNumbers = TRUE,
                                         removePunctuation = TRUE,
                                         stemming=TRUE)
                          )

dim(dtm)
# coerce into dataframe
dtm <- as.data.frame(as.matrix(dtm))

# add issue matrix
themes <- documents[,17:70]

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

  # sort and view
  score <- sort(score)
  score <- tail(score,100) # top  words
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

  st.log.odds <- sort(st.log.odds)
  score <- tail(st.log.odds,50) # top one words
  
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
  score <- tail(score, 100)
  return(cbind(score))
}

################################
##### Testing Classification ###
################################

# make a score
children <- smd("Rights.of.the.Child")
children <- log.odds("Rights.of.the.Child")
children <- diff.prop("Rights.of.the.Child")
migrants <- log.odds("Migrants")

# Score each document
M <- dtm[,rownames(migrants)]
y <- migrants[,1]
x <- apply(M, 1, function(x) sum(x * y))

# put Scores in a data frame
a <- as.data.frame(cbind(x))
names(a) <- "Score"
a$Score <- as.numeric(a$Score)

# add column indicating whether True value and compare scores
a$True <- documents$Migrants
summary(a$Score[a$True==1])
summary(a$Score[a$True==0])

# Model
mod1 <- glm(True ~ Score, data = a, family = binomial(logit))
summary(mod1)

# Predict values
a$Predict <- predict(mod, newdata = a, type = "response")

threshold <- .1
predictedTrue <- which(a$Predict>threshold)
a$Predict[predictedTrue] <- 1
a$Predict[-predictedTrue] <- 0

###############################
##### Evaluation Metrics #######
###############################

# create kappa value
ratings <- data.frame(cbind(a$True, a$Predict))
kappa2(ratings)

# smd: 0.657
# standard log odds - children: 0.743 
# standard log odds - women: 0.825
# stanrd log offs - migrants: 0.845
# st. log odds - migrants, 50 words: .807

# % agree 
length(which(a$Predict == a$True)) / nrow(a) ## .93 not bad!

# f-scores n such
retrieved <- sum(a$Predict)
precision <- sum(a$Predict & a$True) / retrieved
precision
recall <- sum(a$Predict & a$True) / sum(a$True)
recall
Fmeasure <- 2 * precision * recall / (precision + recall)
Fmeasure


# standard log odds with 1000 word dtm: .627
# diff prop: .65


####### Word scores

theme = "Rights.of.the.Child"
index.one <- which(themes[[theme]]==1 & rowSums(themes)==1)
index.rest <- which(themes[[theme]]==0)

# Subset into 2 dtms
one <- dtm[index.one,] 
rest <- dtm[index.rest,]
one <- colSums(one)
rest <- colSums(rest)
df <- data.frame(rbind(one,rest))

# convert DTM to probabilities
m <- df / rowSums(df) # counts to frequencies
m[,1:5]
prob <- sweep(m,2,colSums(m, na.rm=T),`/`) # probability matrix
prob[,1:5]
prob[2,] <- prob[2,] * -1
prob[,1:5]

# create final word scores
scores <- colSums(prob, na.rm = T)

# apply scores
x <- apply(dtm, 1, function(x) sum((x * scores), na.rm = T))
