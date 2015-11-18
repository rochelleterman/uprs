# NETWORK

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
load("datasets.RData")
load("sender-100.RData")

#########################
#### Network Graphs ####
#########################

network <- count(documents, vars = c("To_COW", "From_COW"))
names(network) <- c("source","target","value")
write.csv(network,"network.csv", row.names = F)