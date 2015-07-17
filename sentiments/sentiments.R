### Machine learning

library(plyr)

rm(list=ls())
setwd("~/Dropbox/berkeley/Dissertation/Data and Analyais/Git Repos/uprs")

#load
all <- read.csv("all-data.csv")
erin1 <- read.csv("testing-1/erin-data.csv")
erin2 <- read.csv("testing-2/erin-data.csv")
matt <- read.csv("sentiments/sample-matt-sentiment.csv")

#subset
names(erin1)
erin1 <- erin1[,c("id","sentiment","text")]
erin2 <- erin2[,c("id","sentiment","text")]
matt <- matt[,c('id','sentiment',"text")]
coded <- rbind(matt,erin2,erin1)

# TODO: RANDOMLY SAMPLE DATA

# merge
merge <- merge(all,coded,by="id",all.x=T)
names(merge)
library(RTextTools)

# CREATE THE DOCUMENT-TERM MATRIX
doc_matrix <- create_matrix(coded$text, language="english", removeNumbers=TRUE,
                            stemWords=TRUE, removeSparseTerms=.998)

# CREATE CONTAINER
container <- create_container(doc_matrix, coded$sentiment, trainSize=1:200,
                              testSize=200:300, virgin=FALSE)

# RUN NINE DIFFERENT TRAINING MODELS

#first models take little memory and are thus faster
SVM <- train_model(container,"SVM")
#GLMNET <- train_model(container,"GLMNET")
MAXENT <- train_model(container,"MAXENT")
SLDA <- train_model(container,"SLDA")

#the following models take more memory
BOOSTING <- train_model(container,"BOOSTING")
BAGGING <- train_model(container,"BAGGING")
RF <- train_model(container,"RF")
NNET <- train_model(container,"NNET")
TREE <- train_model(container,"TREE")

# CLASSIFY DATA USING TRAINED MODELS

# we'll only do this on the four low-memory models we used

SVM_CLASSIFY <- classify_model(container, SVM)
#GLMNET_CLASSIFY <- classify_model(container, GLMNET)
MAXENT_CLASSIFY <- classify_model(container, MAXENT)
SLDA_CLASSIFY <- classify_model(container, SLDA)

# the remaining high-memory models we will skip

BOOSTING_CLASSIFY <- classify_model(container, BOOSTING)
BAGGING_CLASSIFY <- classify_model(container, BAGGING)
RF_CLASSIFY <- classify_model(container, RF)
NNET_CLASSIFY <- classify_model(container, NNET)
TREE_CLASSIFY <- classify_model(container, TREE)

### ANALYTICS

analytics <- create_analytics(container,
                              cbind(SVM_CLASSIFY, SLDA_CLASSIFY,MAXENT_CLASSIFY,
                                    BOOSTING_CLASSIFY,BAGGING_CLASSIFY,RF_CLASSIFY,
                                    NNET_CLASSIFY,TREE_CLASSIFY))

summary(analytics)

# RESULTS WILL BE REPORTED BACK IN THE analytics VARIABLE.
# analytics@algorithm_summary: SUMMARY OF PRECISION, RECALL, F-SCORES, AND ACCURACY SORTED BY TOPIC CODE FOR EACH ALGORITHM
# analytics@label_summary: SUMMARY OF LABEL (e.g. TOPIC) ACCURACY
# analytics@document_summary: RAW SUMMARY OF ALL DATA AND SCORING
# analytics@ensemble_summary: SUMMARY OF ENSEMBLE PRECISION/COVERAGE. USES THE n VARIABLE PASSED INTO create_analytics()

create_ensembleSummary(analytics@document_summary)


# N-FOLD CROSS-VALIDATION

SVM <- cross_validate(container, 4, "SVM")
GLMNET <- cross_validate(container, 4, "GLMNET")
MAXENT <- cross_validate(container, 4, "MAXENT")
SLDA <- cross_validate(container, 4, "SLDA")


BAGGING <- cross_validate(container, 4, "BAGGING")
BOOSTING <- cross_validate(container, 4, "BOOSTING")
RF <- cross_validate(container, 4, "RF")
NNET <- cross_validate(container, 4, "NNET")
TREE <- cross_validate(container, 4, "TREE")

#Export output to CSV file. You can export any of the analytics variables

write.csv(analytics@document_summary, "DocumentSummary.csv")
head(USCongress)