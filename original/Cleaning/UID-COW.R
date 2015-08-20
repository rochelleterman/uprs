rm(list=ls())
setwd("~/Dropbox/berkeley/Dissertation/Data and Analyais/Git Repos/uprs/original/Cleaning")

library(countrycode)
library(matrixStats)
library(plyr)
library(reshape2)

######################
#### Load Data ####
######################

documents <- read.csv('~/Dropbox/berkeley/Dissertation/Data and Analyais/Git Repos/uprs/original/Data/upr-orig.csv', stringsAsFactors = F)

names(documents)

######################
#### Country Codes ####
######################

# make 3letter codes for country labels
documents$To_COW <- countrycode(documents$To, "country.name", "cowc")
unique(documents$To[is.na(documents$To_COW)])
documents$To_COW[documents$To=="Serbia"] <- "SRB"
documents$To_COW[documents$To=="serbia"] <- "SRB"
documents$To_COW[documents$To=="kyrgysztan"] <- "KYR"
documents$From_COW[documents$From=="North Korea"] <- "PKR"
documents$To_COW <- as.factor(documents$To_COW)

documents$From_COW <- countrycode(documents$From, "country.name", "cowc")
unique(documents$From[is.na(documents$From_COW)])
documents$From_COW[documents$From=="Serbia"] <- "SRB"
documents$From_COW[documents$From=="Palestine"] <- "PLST"
documents$From_COW <- as.factor(documents$From_COW)

#############################
#### Getting Session Year ####
#############################

# load data and apply COW codes
report.years <- read.csv("~/Dropbox/berkeley/Dissertation/Data\ and\ Analyais/Git\ Repos/uprs/upr-years.csv",stringsAsFactors = F)
report.years$report2[which(report.years$report2==".")] <- 9999
report.years$To_COW <- countrycode(report.years$country, "country.name", "cowc")
unique(report.years$country[is.na(report.years$To_COW)])
report.years$To_COW[report.years$country=="Serbia"] <- "SRB"
report.years$country <- NULL
names(report.years)

# melt data
x<- report.years[,c(1,2,5)]
y <- melt(x,id="To_COW")
x.1 <- report.years[,c(3,4,5)]
y.1 <- melt(x.1,id="To_COW")
report.years <- data.frame(y,y.1)
names(report.years)
report.years <- report.years[,c(1,3,6)]
names(report.years) <- c("To_COW","Session_Year","Year")

# merge
documents <- merge(documents, report.years, by = c("To_COW","Year"), all.x = T)

#############################
#### Getting Sessions Nos ####
#############################

sessions <- read.csv("~/Dropbox/berkeley/Dissertation/Data\ and\ Analyais/Git\ Repos/uprs/sessions.csv")

# First cycle
session.first <- sessions[sessions$Session < 13,c("To_COW","Session"), drop = F]
length(levels(session.first$To_COW))
first <- documents[documents$Session_Year < 2012,]
first$To_COW <- as.factor(first$To_COW)
length(levels(first$To_COW))
# merge and apply
x.1 <- merge(first, session.first, by = "To_COW",all.x = T)

# Second Cycle
session.second <- sessions[sessions$Session>=13,c("To_COW","Session"), drop = F]
second <- documents[documents$Year >= 2012,]
x.2 <- merge(second, session.second,all.x = T)

# bind
documents <- rbind(x.1,x.2)

# rename Year

names(documents)[2] <- "Report_Year"


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

### Order
names(documents)
documents = documents[,c("UID","Session","Session_Year","Report_Year","To","To_COW","From","From_COW","Text","Decision")]

### Write

write.csv(documents,'~/Dropbox/berkeley/Dissertation/Data and Analyais/Git Repos/uprs/original/Data/upr-orig.csv', row.names = F)
