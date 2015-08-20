rm(list=ls())
setwd("~/Dropbox/berkeley/Dissertation/Data and Analyais/Git Repos/uprs/upr-info/Cleaning")

library(countrycode)
library(matrixStats)
library(plyr)

######################
#### Load Data ####
######################

documents <- read.csv('../Data/upr-info-binary.csv', stringsAsFactors = F)

######################
#### Country Codes ####
######################

# make 3letter codes for country labels
documents$To_COW <- countrycode(documents$To, "country.name", "cowc")
unique(documents$To[is.na(documents$To_COW)])
documents$To_COW[documents$To=="Serbia"] <- "SRB"
documents$To_COW[documents$To=="DPR Korea"] <- "PKR"

documents$From_COW <- countrycode(documents$From, "country.name", "cowc")
unique(documents$From[is.na(documents$From_COW)])
documents$From_COW[documents$From=="Serbia"] <- "SRB"
documents$From_COW[documents$From=="Palestine"] <- "PLST"
documents$From_COW[documents$From=="&#40;Unknown&#41;"] <- "NA"
documents$From_COW[documents$From=="DPR Korea"] <- "PKR"

#############
#### UID ####
#############

# arrange
documents <- arrange(documents, To_COW, From_COW, Session, Text)

uid <- function(to, from, session) paste(to, from, session, sep = "-")
documents$UID <- mapply(uid, documents$To_COW, documents$From_COW, documents$Session)
documents$UID[1]

get.par <- function(x){
  return(1:nrow(x))
}

y <- dlply(.data=documents, .variables=.(To_COW, From_COW, Session), get.par)
y[4]

x <- unlist(y)
x[1:20]

uid <- function(uid, par) paste(uid, par, sep="-")
documents$UID <- mapply(uid, documents$UID, x)
documents$UID[1]

### Write

write.csv(documents,'../Data/upr-info-binary.csv', row.names = F)





### Get Country Sessions Data

x <- documents[,c("To","To_COW","Session")]
x <- unique(x)
x <- arrange(x, Session)
x

write.csv(x, "sessions.csv")
