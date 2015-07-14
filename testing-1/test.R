library(foreign)

rm(list=ls())
setwd("~/Dropbox/berkeley/Dissertation/Data and Analyais/Git Repos/uprs")
rochelle <- read.csv("Testing/sample-binary.csv")
erin <- read.csv("Testing/erin-binary.csv")

sort(names(rochelle))
sort(names(erin))

merge <- merge(rochelle, erin,by=c("id"),all=TRUE)
sort(names(merge))
merge <- merge[sort(names(merge))]
names(merge)

write.csv(merge,"testing/merge.csv")

###

results <- read.csv("testing/irr-results.csv")
names(results)

names <- sort(names(erin))
names <- names[-c(91)]

results$Variable <- names
write.csv(results,"testing/irr-results.csv")

