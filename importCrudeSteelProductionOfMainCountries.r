# importCrudeSteelProductionOfMainCountries.r
# Source:The Japan Iron and Steel Federation http://www.jisf.or.jp/
library(XLConnect);library(Nippon);library(lubridate);library(excel.link);library(rvest)
url0 <- 'http://www.jisf.or.jp/data/jikeiretsu/syuyoukoku.html'
htmlMarkup0 <- read_html(url0, encoding = "cp932")
ahrefLists <- htmlMarkup0 %>% html_nodes(xpath = "//a") %>% html_attr("href")
xlsURL <- unique(ahrefLists[grep('\\.xls\\b', ahrefLists, ignore.case = T)])
fileName <- gsub('/','',regmatches(xlsURL, gregexpr('/(\\w)*?\\.xls', xlsURL, fixed = F)))
username <- Sys.info()['user']
pathOutput <- paste0("C:/Users/", username, "/Desktop/R_Data_Write/")
setwd(pathOutput)
if(!file.exists(paste0(pathOutput, fileName))) {
  download.file(paste0('http://www.jisf.or.jp/data/jikeiretsu/',xlsURL), fileName, mode = "wb")
}
buf0 <- readWorksheetFromFile(paste0(pathOutput, fileName), sheet = 1, check.names = F, header = F)
tableTitle <- buf0[1,1]
tableUnit <- buf0[2,43]
buf0[,1] <- as.numeric(buf0[,1])
buf1 <- buf0[apply(buf0,1,function(x)sum(is.na(x)))!=ncol(buf0),]
tmp <- NA
for(rrr in 1:nrow(buf1)){
  if(!is.na(buf1[rrr,1])){tmp <- buf1[rrr,1]}
  buf1[rrr,1] <- tmp
}
tmp <- NA
for(ccc in 1:ncol(buf1)){
  if(!is.na(buf1[2,ccc])){tmp <- buf1[2,ccc]}
  buf1[2,ccc] <- tmp
}
colnames(buf1) <- sapply(gsub('\\s|:na','',paste0(buf1[2,],':',buf1[3,],':',buf1[4,]),ignore.case = T),zen2han)
buf2 <- buf1[!sapply(buf1[,1],is.na),-2]
buf2[,2] <- sapply(gsub('年|月|\\s','',buf2[,2]),zen2han)
tmp <- is.na(as.numeric(substring(buf2[,2],1,1))) 
buf2[tmp,1] <- paste0(buf2[tmp,1],'-01-01')
buf2[tmp,2] <- 'Yearly'
tmp <- grep('yearly|~',buf2[,2],ignore.case = T)
buf2[-tmp,1] <- 
  paste0(buf2[-tmp,1],'-',formatC(as.numeric(buf2[-tmp,2]),width = 2,flag = '0'),'-01')
buf2[-tmp,2] <- 'Monthly'

tmp <- grep('~',buf2[,2],ignore.case = T)
buf2[tmp,1] <- 
  paste0(buf2[tmp,1],'-',buf2[tmp,2])
buf2[tmp,2] <- 'Quaterly'
colnames(buf2)[1:2] <- c('Date','Period')
buf2[,-c(1,2)] <- apply(buf2[,-c(1,2)],2,function(x)as.numeric(gsub(',','',x)))
CrudeSteelProductionOfMainCountries <- buf2
