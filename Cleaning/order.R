library(plyr)

rm(list=ls())
setwd("~/Dropbox/berkeley/Dissertation/Data and Analyais/Git Repos/uprs/Data")
data <- read.csv("all-cown-binary.csv")

# all names
names <- sort(names(data))
# the core fields
core <- c("id","to","to-down","From","from-cown","text","year","notes","theme","institutions","action")
# the non-core fields, or specific codes
codes <- names[!names %in% core]
# append them in order
app <- append(core,codes)
app
# re-order
data <- data[,app]
# write
write.csv(data,"all-binary.csv")

