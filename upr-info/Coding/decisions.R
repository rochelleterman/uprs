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
library(tm)

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

# get rid of last number in UID
orig$UID.1 <- as.character(lapply(orig$UID, beg2char, char = "-", noc = 3))
info$UID.1 <- as.character(lapply(info$UID, beg2char, char = "-", noc = 3))

# get first 5 words of rec
orig$first.word <- as.character(lapply(orig$Text.1, beg2char, char = " ", noc = 5))
info$first.word <- as.character(lapply(info$Text, beg2char, char = " ", noc = 5))

# lower
orig$first.word <- lapply(orig$first.word, tolower)
info$first.word <- lapply(info$first.word, tolower)

#trim
orig$first.word <- as.character(lapply(orig$first.word, Trim))
info$first.word <- as.character(lapply(info$first.word, Trim))

# remove stopwords
orig$first.word  <- rm_stopwords(orig$first.word, tm::stopwords("english"), separate = F, strip = T)
info$first.word  <- rm_stopwords(info$first.word, tm::stopwords("english"), separate = F, strip = T)

# paste uid + first-word
uid <- function(uid, word) paste(uid, word, sep="-")

orig$uid.word <- mapply(uid, orig$UID.1, orig$first.word)
info$uid.word <- mapply(uid, info$UID.1, info$first.word)

orig$uid.word[1:5]
info$uid.word[1:5]

# subset
orig.s <- orig[,c("uid.word", "Decision")]
info.s <- info[,c("uid.word", "Response")]
info.s$n <- as.numeric(rownames(info))

# merge
merge <- merge(orig.s, info.s, all.y = T)
x <- which(duplicated(merge$n))
duplicated <- merge[x,]

# remove duplicates
merge <- merge[-x,]

# set duplicated n to na
merge$Decision[merge$n %in% duplicated$n] <- NA

# check NAs
length(which(is.na(merge$Decision))) # 5945

# add to DF
info$Decision.Guess <- merge$Decision

# fix a couple things
info$Decision.Guess[info$Decision.Guess=="implement"] <- "implemented"

# remove vars
info$first.word <- NULL
info$uid.word <- NULL
info$UID.1 <- NULL

# write.csv
write.csv(info, "upr-info/Data/upr-info-with-decision.csv")

info$Decision.Guess <- as.factor(info$Decision.Guess)
summary(info$Decision.Guess)
levels(info$Decision.Guess)

1 - (5945 /41066)
