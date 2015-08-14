rm(list=ls())
setwd("~/Dropbox/berkeley/Dissertation/Data and Analyais/Git Repos/uprs/Analysis")

library(plyr)
library(RTextTools)
library(qdap)
library(stringr)
library(mallet)
library(corrgram)
library(pvclust)
library(countrycode)
library(matrixStats)
library(lsa)
library('dendextend')
library('dendextendRcpp')
library(ggplot2)

######################
#### Prepare Data ####
######################

documents <- read.csv('~/Dropbox/berkeley/Dissertation/Data and Analyais/Git Repos/uprs/Data/all-cown-binary.csv', stringsAsFactors = F)
names <- cbind(names(documents))
write.csv(names, "variables.csv")

# make 3letter codes for country labels
documents$to_COW <- countrycode(documents$to_COW, "cown", "cowc")
documents$from_COW <- countrycode(documents$from_COW, "cown", "cowc")

# subset
recs <- documents[,c(3,5,6,79:131)] # just keep to, from, year, themes

# report as unit of observation
temp = recs[,c(1,3:56)]
reports <- ddply(.data=temp, .variables=.(to_COW,year), numcolwise(sum,na.rm = TRUE))
row.names(reports) <- paste(reports$to_COW,reports$year,sep="-")
reports <- reports[,-c(1,2)]

# themes as unit of observation
names(recs)
themes <- recs[,c(4:56)]
themes.t <- data.frame(t(themes))

# sender as UOA
temp <- recs[,c(2,4:56)]
sender <- ddply(.data=temp, .variables=.(from_COW), numcolwise(sum,na.rm = TRUE))
sender$from_COW[is.na(sender$from_COW)] <- "PLST"
row.names(sender) <- sender$from_COW
sender$from_COW <- NULL

# institutions
inst <- documents[,c(12:64)] # just keep to, from, year, institutions

###########################
#### Descriptive Stats ###
##########################

# number of recs per institution
n.institutions <- as.data.frame(colSums(inst))
names(n.institutions) <- "Counts"
n.institutions$Proportions <- n.institutions$Count/sum(n.institutions$Count)
write.csv(n.institutions, "Results/recs-per-institution.csv")

topInst <- head(n.institutions[order(n.institutions$Counts, decreasing = T),],10)
topInst$institution <- ordered(row.names(topInst), levels = row.names(topInst))

topInst  %>%
  ggplot (aes(institution, Counts)) +
  geom_bar (stat ="identity") +
  theme(axis.text.x=element_text(angle=45,hjust=1)) +
  ggtitle("10 Most Common Institutions")

# number of recs per theme
n.themes <- as.data.frame(colSums(themes))
names(n.themes) <- "Counts"
n.themes$Proportions <- n.themes$Count/sum(n.themes$Count)
write.csv(n.themes, "Results/recs-per-theme.csv")

topTheme <- head(n.themes[order(n.themes$Counts, decreasing = T),],10)
topTheme$Theme <- ordered(row.names(topTheme), levels = row.names(topTheme))

topTheme  %>%
  ggplot (aes(theme, Counts)) +
  geom_bar (stat ="identity") +
  theme(axis.text.x=element_text(angle=45,hjust=1)) +
  ggtitle("10 Most Common Institutions")

# number of recs per sender
n.sender <- cbind(rownames(sender),rowSums(sender))
write.csv(n.sender,"Results/recs-per-sender.csv")

# keep only those who give at least 100 recs
sender.100 <- sender[rowSums(sender) > 100,] 
n.sender.100<- cbind(rownames(sender.100),rowSums(sender.100))
write.csv(n.sender.100,"Results/recs-per-sender-100.csv")

# number of recs with only >100 senders
recs.100 <- recs[recs$from_COW %in% rownames(sender.100),]
nrow(recs.100) / nrow(recs)

#############################
#### Clustering - theme ###
#############################

# http://research.stowers-institute.org/mcm/efg/R/Visualization/cor-cluster/index.htm
data <- themes[,which(colSums(themes)>50)]

# correlations
data$culture <- NULL

correlations <- as.data.frame(cor(data))
corrgram(correlations)

dissimilarity <- 1 - cor(data)
dissimilarity

distance <- as.dist(dissimilarity)
round(distance, 4) 

# Create a dend:
dend <- distance %>% hclust %>% as.dendrogram

# and plot it:
par(mar=c(8,5,2,2))

dend %>% 
  set("labels_col", value = c("maroon2","red","orange","orange","olivedrab3","olivedrab3","steelblue2","royalblue4","purple","purple"), k=10) %>% 
  set("branches_k_color", value = c("maroon2","red","orange","orange","olivedrab3","olivedrab3","steelblue2","royalblue4","purple","purple"), k=10) %>% 
  #set("labels_cex", .7) %>% 
  plot
dend %>% rect.dendrogram(k=2, border = 8, lty = 5, lwd = 2)

#############################################
#### Clustering - Themes based on Reports ###
#############################################

data <- reports[,which(colSums(reports)>50)]

### CORRELATIONS

data$culture <- NULL

correlations <- as.data.frame(cor(data))
dissimilarity <- 1 - cor(data)
dissimilarity
d <- as.dist(dissimilarity)
round(d, 4) 

# Create a dend:
dend <- d %>% hclust %>% as.dendrogram

# and plot it:
par(mar=c(8,5,2,2))

dend %>% 
  set("labels_col", k=10) %>% 
  set("branches_k_color", k=10) %>% 
  #set("labels_cex", .7) %>% 
  plot
dend %>% rect.dendrogram(k=2, border = 8, lty = 5, lwd = 2)

## COSINE

d <- cosine(as.matrix(data))
d <- as.dist(1-d) 
d

# Create a dend:
dend <- d %>% hclust %>% as.dendrogram

# and plot it:
dend %>% 
  set("labels_col", k=10) %>% 
  set("branches_k_color", k=10) %>% 
  #set("labels_cex", .7) %>% 
  plot
dend %>% rect.dendrogram(k=2, border = 8, lty = 5, lwd = 2)

##############################
#### Clustering - Sender ###
##############################

# correlations
data = as.data.frame(t(sender))

correlations <- as.data.frame(cor(data))
# corrgram(correlations)

dissimilarity <- 1 - cor(data)
distance <- as.dist(dissimilarity)
round(distance, 4) 

plot(hclust(distance), 
     main="Dissimilarity = 1 - Correlation", xlab="")

# euclidean distance
data <- sender
d <- dist(data,method="euclidean")
plot(hclust(d), main="Dissimilarity = Euclid", xlab="")

# cosign
data = as.data.frame(t(sender))

d <- cosine(as.matrix(data))
d <- as.dist(1-d) 
plot(hclust(d), main = "Dissimilarity = 1 - Cosine")

#cluster.bootstrap <- pvclust(correlations, nboot=1000, method.dist="abscor")
#plot(cluster.bootstrap)
#pvrect(cluster.bootstrap)


