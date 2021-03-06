rm(list=ls())
setwd("~/Dropbox/berkeley/Dissertation/Data and Analyais/Git Repos/uprs/Analysis")

library(corrgram)
library(pvclust)
library(countrycode)
library(matrixStats)
library(lsa)
library('dendextend')
library('dendextendRcpp')
library(ggplot2)
library(readstata13)

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
n.institutions$Proportions <- n.institutions$Count/nrow(recs)
write.csv(n.institutions, "Results/Descriptive/recs-per-institution.csv")

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
n.themes$Proportions <- n.themes$Count/nrow(recs)
write.csv(n.themes, "Results/Descriptive/recs-per-theme.csv")

topTheme <- head(n.themes[order(n.themes$Counts, decreasing = T),],10)
topTheme$Theme <- ordered(row.names(topTheme), levels = row.names(topTheme))

topTheme  %>%
  ggplot (aes(Theme, Counts)) +
  geom_bar (stat ="identity") +
  theme(axis.text.x=element_text(angle=45,hjust=1)) +
  ggtitle("10 Most Common Themes")

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
data$culture <- NULL

# correlations
correlations <- as.data.frame(cor(data))
#corrgram(correlations)

dissimilarity <- 1 - cor(data)
dissimilarity

distance <- as.dist(dissimilarity)
round(distance, 4) 

# Create a dend
dend <- distance %>% hclust %>% as.dendrogram

# and plot it:
par(mar=c(8,5,2,2))

dend %>% 
  set("labels_col", value = c("maroon2","red","orange","orange","olivedrab3","olivedrab3","steelblue2","royalblue4","purple","purple"), k=10) %>% 
  set("branches_k_color", value = c("maroon2","red","orange","orange","olivedrab3","olivedrab3","steelblue2","royalblue4","purple","purple"), k=10) %>% 
  #set("labels_cex", .7) %>% 
  plot
dend %>% rect.dendrogram(k=2, border = 8, lty = 5, lwd = 2)

# assigning groups
dend %>% labels
civil <- labels(dend)[1:3]
security <- labels(dend)[4:9]
political <- labels(dend)[10:16]
childmigrants <- labels(dend)[17:21]
women <- labels(dend)[22:28]
discrimination <- labels(dend)[29:33]
socio.econ <- labels(dend)[34:46]

# write function to get number of recs per cluster
get.cluster.n <- function(cluster){
  # subset recs with only columsn in cluster
  y <- recs[,colnames(recs) %in% cluster]
  
  # subset recs with at least 1 theme in cluster
  y.yes <- y[rowSums(y) > 0,]
  
  return(nrow(y.yes))
}
get.cluster.n(women)

# make data frame of cluster - n values
cluster <- c('civil','security','political','childmigrants','women','discrimination','socio.econ')
counts <- c(get.cluster.n(civil),
            get.cluster.n(security),
            get.cluster.n(political),
            get.cluster.n(childmigrants),
            get.cluster.n(women),
            get.cluster.n(discrimination),
            get.cluster.n(socio.econ)
            )
n.cluster <- data.frame(cluster,counts)
n.cluster$proportions <- n.cluster$count/nrow(recs)
n.cluster$cluster <- ordered(n.cluster$cluster, levels = n.cluster$cluster)
n.cluster

# save it
write.csv(n.cluster,"Results/Clustering/recs-per-cluster.csv")

# plot it

n.cluster  %>%
  ggplot (aes(cluster, proportions)) +
  geom_bar (stat ="identity") +
  theme(axis.text.x=element_text(angle=45,hjust=1)) +
  ggtitle("Proportion of Recommendations Per Cluster")

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
dend <- as.dendrogram(hclust(d, method="single"))

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
data <- sender.100
d <- dist(data,method="euclidean")
d


# cosign
data = as.data.frame(t(sender.100))

d <- cosine(as.matrix(data))
d <- as.dist(1-d) 
d
#plot(hclust(d), main = "Dissimilarity = 1 - Cosine")

# Create a dend:
dend <- d %>% hclust %>% as.dendrogram

# and plot it:
dend %>% 
  set("labels_col") %>% 
  set("branches_k_color", k=10) %>% 
  set("labels_cex", .5) %>% 
  hang.dendrogram %>% # hang the leaves
  plot
dend %>% rect.dendrogram(k=6, border = 8, lty = 5, lwd = 2)

#######
dat <- read.dta13("~/Dropbox/UPRproject/AnalysisErik/Dyadicdata.dta")
dat.rec <- dat[dat$recommendation>0,]