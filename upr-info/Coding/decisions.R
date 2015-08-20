### Merging Decisions

rm(list=ls())
setwd("~/Dropbox/berkeley/Dissertation/Data and Analyais/Git Repos/uprs/")

library(corrgram)
library(countrycode)
library(matrixStats)
library(ggplot2)
library(readstata13)
library(plyr)
library(qdap)

# Load Data
info <- read.csv('upr-info/Data/upr-info.csv', stringsAsFactors = F)
# take out voluntary pledges
info <- info[!info$Response=="Voluntary Pledge",]

info <- arrange(info, To_COW, From_COW, Session, Text)

# original
orig <- read.csv('original/Data/upr-orig.csv', stringsAsFactors = F)
orig <- arrange(orig, To_COW, From_COW, Session, Text)

## get rid of starting numbers in text
rid.index <- function(text){
  index <- beg2char(text, " ",include=TRUE)
  return(gsub(index, "", text))
}  
orig$Text.1 <- lapply(orig$Text,rid.index)
orig$Text.1 <- as.character(orig$Text.1)


###

# get matching IDs

orig$UID <- as.character(lapply(orig$UID, beg2char, char = "-", noc = 3))
info$UID <- as.character(lapply(info$UID, beg2char, char = "-", noc = 3))

orig$first.word <- as.character(lapply(orig$Text.1, beg2char, char = " ", noc = 2))
info$first.word <- as.character(lapply(info$Text, beg2char, char = " ", noc = 2))

uid <- function(uid, word) paste(uid, word, sep="-")

orig$uid.word <- mapply(uid, orig$UID, orig$first.word)
info$uid.word <- mapply(uid, info$UID, info$first.word)

orig$uid.word[1:5]
info$uid.word[1:5]

# subset

orig.s <- orig[,c("uid.word", "Decision")]
info.s <- info[,c("uid.word", "Response")]
info.s$n <- as.numeric(rownames(info))

merge <- merge(orig.s, info.s, all.y = T)
duplicated <- merge[which(duplicated(merge$n)),]

x <- unique(merge$n)
merge <- merge[x,]

length(which(is.na(merge$Decision)))

merge$Decision[-x]

pkr <- info[info$To_COW=="PKR",]
