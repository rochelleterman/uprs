library(plyr)

rm(list=ls())
setwd("~/Dropbox/berkeley/Dissertation/Data and Analyais/Git Repos/uprs")
rochelle <- read.csv("Testing-2/sample-binary.csv")
erin <- read.csv("Testing-2/erin-binary.csv")

sort(names(rochelle))
sort(names(erin))

merge <- merge(rochelle, erin,by=c("id"),all=TRUE)
sort(names(merge))
merge <- merge[sort(names(merge))]
names(merge)
merge$id <- NULL
merge$notes <- NULL


write.csv(merge,"testing-2/merge.csv")

###

results <- read.csv("testing-2/irr-results.csv")
names(results)

names <- sort(names(rochelle))
names <- names[-c(48)]
names

results$Variable <- names
write.csv(results,"testing-2/irr-results.csv")
names(results)
results <- arrange(results, Cohen.s.Kappa)
head(results,10)
