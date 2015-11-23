setwd("~/Dropbox/berkeley/Git-Repos/uprs/v.1/Cleaning")

# merge haiti
all.orig <- read.csv("Data/all-data.csv")
all <- read.csv("Data/all-data-cown.csv")
names(all)
all <- all[, c("text","to","decision","From","year","id","to_COW","from_COW")]
haiti <- read.csv("Data/year-csvs/haiti2011.csv")
names(haiti) <- c("text","to","decision","From","year")
haiti$id <- NA

which(duplicated(all$id))

cow <- data.frame(cbind(as.character(all$From),all$from_COW))
cow <- cow[!duplicated(cow),]
names(cow) <- c("From","from_COW")

haiti$to_COW <- 41
haiti <- merge(haiti,by = "From",cow,all.x=T)
haiti <- haiti[,c("text","to", "decision","From","year","id","to_COW","from_COW")]

names(haiti)
names(all)

x<- sort(all$id)
max(x)

all.plus <- rbind(all,haiti)

all.plus$id[39194:39329] <- 39193:(39193 + 135)

write.csv(all.plus, "Data/all-data-cown.csv")


