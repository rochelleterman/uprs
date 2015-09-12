# Prepare datasets for analyses

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
library(matrixStats)

######################
#### Prepare Data ####
######################

documents <- read.csv('../Data/upr-info-binary.csv', stringsAsFactors = F)

# should be 41066
nrow(documents)

# subset
recs <- documents[,c(4,8,2,18:71)] # just keep to, from, session, issues

# REPORT as unit of observation
temp = recs[,c(1,3,4:57)] # keep to, session, issues
reports <- ddply(.data=temp, .variables=.(To_COW,Session), numcolwise(sum,na.rm = TRUE))
row.names(reports) <- paste(reports$To_COW,reports$Session,sep="-")
reports <- reports[,-c(1,2)]

# THEMES as unit of observation
themes <- recs[,c(4:57)] # should be 54 obs
themes.t <- data.frame(t(themes))

# SENDER as UOA
temp <- recs[,c(2,4:57)] # from, issues
sender <- ddply(.data=temp, .variables=.(From_COW), numcolwise(sum,na.rm = TRUE))
sender <- sender[!is.na(sender$From_COW),]
row.names(sender) <- sender$From_COW
sender$From_COW <- NULL

# INSTITUTIONS as obs.
inst <- documents[,c(72:124)] # just institutions

save(recs, reports, themes, sender, inst, file = "datasets.RData")