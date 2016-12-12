# importWorldGoldCouncilPriceData.r
# Source:World Gold Council http://www.gold.org/
library(XLConnect);library(Nippon);library(lubridate);library(excel.link);library(rvest)
url0 <- 'http://www.gold.org/statistics#historical-prices'
htmlMarkup0 <- read_html(url0, encoding = "utf8")
ahrefLists <- htmlMarkup0 %>% html_nodes(xpath = "//a") %>% html_attr("href")
xlsURL <- unique(ahrefLists[grep('Prices.xls\\b', ahrefLists, ignore.case = T)])
fileName <- gsub('/','',regmatches(xlsURL, gregexpr('/(\\w)*?\\.xls', xlsURL, fixed = F)))
username <- Sys.info()['user']
pathOutput <- paste0("C:/Users/", username, "/Desktop/R_Data_Write/")
setwd(pathOutput)
if(!file.exists(paste0(pathOutput, fileName))) {
  download.file(paste0('http://www.gold.org',xlsURL), fileName, mode = "wb")
}
buf0 <- readWorksheetFromFile(paste0(pathOutput, fileName), sheet = 'Daily', check.names = F, header = F)
bufRRR <- which(apply(buf0,1,function(x)length(grep('name',x,ignore.case = T)))!=0)
colnames(buf0) <- buf0[bufRRR,]
title <- buf0[6,5]
buf1 <- buf0[-c(1:bufRRR),]
bufColnames <- colnames(buf1)
bufCCC <- which(apply(buf1,2,function(x)sum(is.na(x)))!=nrow(buf1))
buf1 <- buf1[,bufCCC]
colnames(buf1) <- bufColnames[bufCCC]
colnames(buf1)[grep('\\bname\\b',colnames(buf1),ignore.case = T)] <- 'Date'
bufCCC <- grep('date',colnames(buf1),ignore.case = T)
buf1[,bufCCC] <- as.Date(buf1[,bufCCC])
buf1[,-bufCCC] <- apply(buf1[,-bufCCC],2,function(x)as.numeric(gsub(',','',x)))
goldPriceData <- buf1
