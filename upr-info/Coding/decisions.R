### Merging Decisions

rm(list=ls())
setwd("~/Dropbox/berkeley/Dissertation/Data and Analyais/Git Repos/uprs/")

library(corrgram)
library(countrycode)
library(matrixStats)
library(ggplot2)
library(readstata13)
library(plyr)

# Load Data
info <- read.csv('upr-info/Data/upr-info.csv', stringsAsFactors = F)
# take out voluntary pledges
info <- info[!info$Response=="Voluntary Pledge",]

info <- arrange(info, To_COW, From_COW, Session, Text)

# original
orig <- read.csv('original/Data/upr-orig.csv', stringsAsFactors = F)
orig <- arrange(orig, To_COW, From_COW, Session, Text)

###

orig$UID[1:5]
info$UID[1:5]
