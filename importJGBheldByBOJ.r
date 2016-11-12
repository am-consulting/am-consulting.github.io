library (RCurl);library(XLConnect)
username <- Sys.info()['user']
pathOutput <- paste0("C:/Users/", username, "/Desktop/R_Data_Write/")
setwd(pathOutput)
sourceURL <- 'https://www.boj.or.jp/statistics/boj/other/mei/'
htmlMarkup <- iconv(getURL(sourceURL, ssl.verifyPeer = F, .encoding = "shift_jis"), "shift_jis", "UTF-8")
pattern <- "[mei]+?.+?\\.zip"
zipFiles <- regmatches(htmlMarkup, gregexpr(pattern, htmlMarkup, fixed = F))
zipFiles <- unlist(zipFiles)
pattern <- "(<a href=\")+?.*?\\.zip\">"
urls <- regmatches(htmlMarkup, gregexpr(pattern, htmlMarkup, fixed = F))
urls <- unlist(urls)
urls <- paste0('https://www.boj.or.jp',gsub('\">','',gsub('<a href=\"','',urls)))
download.file(urls[1], zipFiles[1], mode = 'wb')
unzip(zipFiles[1])
buf0 <-
  readWorksheetFromFile(paste0(pathOutput, gsub('.zip','.xls',zipFiles[1])), sheet = 1, check.names = F, header = F)
title <- paste0(buf0[3,3],buf0[4,3])
dfR  <- which(apply(buf0,1,function(x)length(grep('銘柄',x)))!=0)[2]
dfC1 <- which(apply(buf0,2,function(x)length(grep('銘柄',x)))!=0)[1]
dfC2 <- which(apply(buf0,2,function(x)length(grep('保有残高',x)))!=0)[1]
buf0[is.na(buf0)] <- ''
buf0[dfR,] <- paste0(buf0[dfR,],buf0[dfR-1,])
buf <- buf0[dfR:nrow(buf0),dfC1:dfC2]
colnames(buf) <- buf[1,]
buf <- buf[-1,]
buf[,3] <- as.numeric(gsub(',','',buf[,3]))
buf <- na.omit(buf)
colnames(buf)[2] <- 'x回債'
assign('JGBheldByBOJ', buf, envir = .GlobalEnv)