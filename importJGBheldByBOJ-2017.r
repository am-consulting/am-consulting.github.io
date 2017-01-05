library (RCurl);library(XLConnect);library(rvest)
username <-
  Sys.info()['user']
pathOutput <-
  paste0("C:/Users/", username, "/Desktop/R_Data_Write/")
setwd(pathOutput)
htmlMarkup <-
  read_html('https://www.boj.or.jp/statistics/boj/other/mei/index.htm/',
            encoding = "utf-8")
linkList <-
  htmlMarkup %>% html_nodes(xpath = "//a") %>% html_attr("href")
xlsxList <-
  linkList[grep('\\.xlsx', linkList)]
fileName <-
  'JGBheldByBOJ.xlsx'
download.file(paste0('https://www.boj.or.jp', xlsxList[1]),
              fileName,
              mode = 'wb')
buf0 <-
  readWorksheetFromFile(paste0(pathOutput, fileName), sheet = 1, check.names = F, header = F)
title <-
  paste0(buf0[3,3],buf0[4,3])
dfR  <-
  which(apply(buf0,1,function(x)length(grep('銘柄',x)))!=0)[2]
dfC1 <-
  which(apply(buf0,2,function(x)length(grep('銘柄',x)))!=0)[1]
dfC2 <-
  which(apply(buf0,2,function(x)length(grep('保有残高',x)))!=0)[1]
buf0[dfR,] <-
  paste0(buf0[dfR,],buf0[dfR-1,])
buf <-
  buf0[dfR:nrow(buf0),dfC1:dfC2]
colnames(buf) <-
  buf[1,]
buf <-
  buf[-1,]
buf[,3] <-
  as.numeric(gsub(',','',buf[,3]))
buf <-
  na.omit(buf)
colnames(buf) <-
  gsub('NA','',colnames(buf))
colnames(buf)[2] <-
  'x回債'
assign('JGBheldByBOJ',
       buf,
       envir = .GlobalEnv)
