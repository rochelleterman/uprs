### Getting sentiment values

# Required packages
library(plyr)
library(RTextTools)
library(irr)
library(qdap)
library(stringr)

rm(list=ls())
setwd("~/Dropbox/berkeley/Dissertation/Data and Analyais/Git Repos/uprs/upr-info/Analysis")

###########################
##### Load Coded Data #####
###########################

documents <- read.csv('../Data/upr-info-binary.csv', stringsAsFactors = F)

# should be 41066
nrow(documents)

# take subset for now

documents<- documents[1:10000,]

##############################################
##### Machine Learning - Test models #########
##############################################

# PREPARE TRAINING AND TEST SETS
all <- 1:nrow(documents)
training <- sample(all, 7000)
test <- all[! all %in% training]

# CREATE THE DOCUMENT-TERM MATRIX
doc_matrix <- create_matrix(documents$Text, language="english", removeNumbers=TRUE,
                            stemWords=TRUE, removeSparseTerms=.999)

dim(doc_matrix)

# CREATE CONTAINER
container <- create_container(doc_matrix, documents$Rights.of.the.Child, trainSize=training,
                              testSize=test, virgin=F)

# RUN NINE DIFFERENT TRAINING MODELS
# TODO: Add: "MAXENT", "GLMNET", "NNET"

SVM <- train_model(container,"SVM")
SLDA <- train_model(container,"SLDA")
BOOSTING <- train_model(container,"BOOSTING")
BAGGING <- train_model(container,"BAGGING")
RF <- train_model(container,"RF")
TREE <- train_model(container,"TREE")

# CLASSIFY DATA USING TRAINED MODELS

SVM_CLASSIFY <- classify_model(container, SVM)
SLDA_CLASSIFY <- classify_model(container, SLDA)
BOOSTING_CLASSIFY <- classify_model(container, BOOSTING)
BAGGING_CLASSIFY <- classify_model(container, BAGGING)
RF_CLASSIFY <- classify_model(container, RF)
TREE_CLASSIFY <- classify_model(container, TREE)

### ANALYTICS

analytics <- create_analytics(container,
                              cbind(SVM_CLASSIFY, SLDA_CLASSIFY,#MAXENT_CLASSIFY,
                                    BOOSTING_CLASSIFY,BAGGING_CLASSIFY
                                    #,RF_CLASSIFY,
                                    #TREE_CLASSIFY
                                    ))
summary(analytics)

# analytics@algorithm_summary: SUMMARY OF PRECISION, RECALL, F-SCORES, AND ACCURACY SORTED BY TOPIC CODE FOR EACH ALGORITHM
# analytics@label_summary: SUMMARY OF LABEL (e.g. TOPIC) ACCURACY
# analytics@document_summary: RAW SUMMARY OF ALL DATA AND SCORING
# analytics@ensemble_summary: SUMMARY OF ENSEMBLE PRECISION/COVERAGE. USES THE n VARIABLE PASSED INTO create_analytics()

create_ensembleSummary(analytics@document_summary)
analytics@label_summary

#Export output to CSV file. You can export any of the analytics variables

write.csv(analytics@document_summary, "Results/DocumentSummary-test.csv")

########################################
## APPLYING CLASSIFIER TO VIRGIN DATA ##
########################################

# PREPARE DATA

# load data
all.data <- read.csv("../Data/all-data-cown.csv")

# merge to get sentiments
coded <- coded[,c("id","sentiment")]
all.data <- merge(all.data, coded, by = "id", all.x = T)

# training and testing sets
train <- which(!is.na(all.data$sentiment))
test <- which(is.na(all.data$sentiment))

# make matrix
new_matrix <- create_matrix(all.data$text, language="english", removeNumbers=TRUE,
                            stemWords=TRUE, removeSparseTerms=.99)

# create container
container <- create_container(new_matrix, all.data$sentiment, trainSize = train, testSize = test, virgin=T)

# TRAIN MODELS

SVM <- train_model(container,"SVM")
SLDA <- train_model(container,"SLDA")
BOOSTING <- train_model(container,"BOOSTING")
BAGGING <- train_model(container,"BAGGING")
RF <- train_model(container,"RF")
TREE <- train_model(container,"TREE")

# CLASSIFY DATA USING TRAINED MODELS (above)

SVM_CLASSIFY <- classify_model(container, SVM)
SLDA_CLASSIFY <- classify_model(container, SLDA)
BOOSTING_CLASSIFY <- classify_model(container, BOOSTING)
BAGGING_CLASSIFY <- classify_model(container, BAGGING)
RF_CLASSIFY <- classify_model(container, RF)
TREE_CLASSIFY <- classify_model(container, TREE)


### ANALYTICS

analytics <- create_analytics(container,cbind(SVM_CLASSIFY, SLDA_CLASSIFY,#MAXENT_CLASSIFY,
                                                   BOOSTING_CLASSIFY,BAGGING_CLASSIFY,RF_CLASSIFY,
                                                   TREE_CLASSIFY))
summary(analytics)


create_ensembleSummary(analytics@document_summary)
analytics@label_summary

doc_summary <- analytics@document_summary

#Export output to CSV file. You can export any of the analytics variables

write.csv(analytics@document_summary, "Results/DocumentSummary.csv")

# APPLY RESULTS TO DATA FRAME

# create boolean variable for whether sentiment is hand-coded (1) or machine-coded (0)
all.data$sent.label <- 0
all.data$sent.label[train] <- 1

all.data$sentiment[test] <- doc_summary$CONSENSUS_CODE
all.data$consensus.agree <- NA
all.data$consensus.agree[test] <- doc_summary$CONSENSUS_AGREE

all.data$sentiment <- as.numeric(all.data$sentiment)

# save data
write.csv(all.data,"../Data/all-data-with-sentiment.csv",row.names=F)


# N-FOLD CROSS-VALIDATION

SVM <- cross_validate(container, 4, "SVM")
#GLMNET <- cross_validate(container, 4, "GLMNET")
#MAXENT <- cross_validate(container, 4, "MAXENT")
SLDA <- cross_validate(container, 4, "SLDA")
BAGGING <- cross_validate(container, 4, "BAGGING")
BOOSTING <- cross_validate(container, 4, "BOOSTING")
RF <- cross_validate(container, 4, "RF")
NNET <- cross_validate(container, 4, "NNET")
TREE <- cross_validate(container, 4, "TREE")


#################################
##### Sentiment Analysis QDAP ###
#################################

all <- read.csv("all-data.csv")
all <- all[,c("id","to","From","year","text")]
all$text <- as.character(all$text)
truncdf(all[1:10, ])

# get rid of starting numbers
rid.index <- function(text){
  index <- beg2char(text, " ",include=TRUE)
  return(gsub(index, " ", text))
}  
all$text <- lapply(all$text,rid.index)

# get rid of countries at the end
rid.countries <- function(text){
  index <- char2end(text, "(",include=TRUE)
  return(gsub(index, ".", text,fixed=T))
}  
all$text <- lapply(all$text,rid.countries)

#strip whitespace
all$text <- Trim(all$text)

x <- sentSplit(all,text.var="text")
subset <- x[1:100,]

## sent.
(poldat <- with(subset, polarity(text)))
plot(poldat)
pol <- poldat$all
