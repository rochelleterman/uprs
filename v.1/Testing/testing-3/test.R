library(plyr)

rm(list=ls())
setwd("~/Dropbox/berkeley/Dissertation/Data and Analyais/Git Repos/uprs/testing/testing-3")
rochelle <- read.csv("sample-binary.csv")
erin <- read.csv("erin-binary.csv")

sort(names(rochelle))
sort(names(erin))

merge <- merge(rochelle, erin,by=c("id"),all=TRUE)
sort(names(merge))
merge <- merge[sort(names(merge))]
names(merge)
merge$id <- NULL
merge$notes <- NULL

write.csv(merge,"merge.csv")

### Analysis

results <- read.csv("irr-results-after.csv")
names(results)

names <- sort(names(rochelle))
names <- names[-c(48)]
names

results$Variable <- names
names(results)
results <- arrange(results, Cohen.s.Kappa)
head(results,10)
head(results,50)

write.csv(results,"irr-results-after.csv")
