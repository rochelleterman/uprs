# Calculating some descriptive stats

rm(list=ls())
setwd("~/Dropbox/berkeley/Dissertation/Data and Analyais/Git Repos/uprs/v.2/Analysis")

library(corrgram)
library(pvclust)
library(countrycode)
library(lsa)
library('dendextend')
library('dendextendRcpp')
library(ggplot2)
library(readstata13)
library(plyr)

######################
#### Prepare Data ####
######################

documents <- read.csv('../Data/upr-info-binary.csv', stringsAsFactors = F)
load("Data/datasets.RData")

# should be 41066
nrow(documents)

##################################
#### Number of recs per REPORT ###
##################################

temp = recs[,c(1,3,4:57)] # keep to, session, issues
n.report <- count(temp, vars = c("To_COW", "Session"))
n.report <- arrange(n.report, freq)

#######################################
#### Number of recs per INSTITUTION ###
#######################################

n.institutions <- as.data.frame(colSums(inst))
names(n.institutions) <- "Counts"
n.institutions$Proportions <- n.institutions$Count/nrow(recs)
write.csv(n.institutions, "Results/Descriptive/recs-per-institution.csv")

topInst <- head(n.institutions[order(n.institutions$Counts, decreasing = T),],10)
topInst$institution <- ordered(row.names(topInst), levels = row.names(topInst))

topInst  %>%
  ggplot (aes(institution, Counts, fill = institution)) +
  geom_bar(stat ="identity") +
  theme(axis.text.x=element_text(angle=45,hjust=1)) +
  ggtitle("10 Most Common Institutions")

#################################
#### Number of recs per THEME ###
#################################

n.themes <- as.data.frame(colSums(themes))
names(n.themes) <- "Counts"
sum(n.themes$Counts)
n.themes$Proportions <- n.themes$Count/nrow(recs)
write.csv(n.themes, "Results/Descriptive/recs-per-theme.csv")

topTheme <- head(n.themes[order(n.themes$Counts, decreasing = T),],10)
topTheme$Theme <- ordered(row.names(topTheme), levels = row.names(topTheme))

topTheme  %>%
  ggplot (aes(Theme, Counts, fill=Theme)) +
  geom_bar (stat ="identity") +
  theme(axis.text.x=element_text(angle=45,hjust=1)) +
  ggtitle("10 Most Common Themes")

##################################
#### Number of recs per SENDER ###
##################################

recs$From_COW <- as.factor(recs$From_COW)
n.sender <- count(documents, "From_COW")
sum(n.sender$freq) # should be 41066
n.sender$Proportions <- n.sender$freq/41066
write.csv(n.sender,"Results/Descriptive/recs-per-sender.csv")

topSender <- n.sender[order(n.sender$freq, decreasing = T),]
topSender <- topSender[topSender$freq > 500,]

names(topSender)
topSender$Country <- ordered(topSender$From_COW, levels = topSender$From_COW)

topSender  %>%
  ggplot(aes(Country, freq)) +
  geom_point (stat ="identity") +
  theme(axis.text.x=element_text(angle=45,hjust=1)) +
  ggtitle("Most Active Countries")

# keep only those who give at least 100 recs
n.sender.100 <- n.sender[n.sender$freq > 100,]
sender.100 <- sender[row.names(sender) %in% n.sender.100$From_COW,]
save(sender.100, file = "Data/sender-100.RData")
write.csv(n.sender.100,"Results/Descriptive/recs-per-sender-100.csv")

# number of recs with only >100 senders
recs.100 <- recs[recs$From_COW %in% n.sender.100$From_COW,]
nrow(recs.100) / nrow(recs)

######################################
#### SENDERS & THEME RELATIONSHIPS ###
######################################

# normalize sender props
sender.norm <- sweep(sender.100,2,colSums(sender.100),`/`)
sum(sender.norm$Asylum.seekers...refugees) # should be 1
write.csv(sender.norm, "Results/Descriptive/prop-themes-per-sender.csv")

# Find top countries for each theme
x <- apply(sender.norm, 2, which.max)
y <- sender.norm[x,]  
top.senders.themes <- cbind(names(x), rownames(y), diag(as.matrix(y)))
write.csv("Results/Descriptive/top-senders-theme.csv")

which(sender.norm == max(sender.norm), arr.ind = TRUE)
names(sender.norm)[12] # disappearances...?

###########################
#### SUMMARY OF ACTIONS ###
###########################

table(documents$Action)
write.csv(table(documents$Action),"Results/Descriptive/Actions.csv")
