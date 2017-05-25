# http://www.mlit.go.jp/toukeijouhou/chojou/rodo.htm
# 建設労働需給調査結果
library(RCurl);library(XLConnect);library(Nippon);library(lubridate)
sourceURL <- 'http://www.mlit.go.jp/toukeijouhou/chojou/rodo.htm'
htmlMarkup <- iconv(getURL(sourceURL, ssl.verifyPeer = F, .encoding = "shift_jis"), "shift_jis", "UTF-8")
pattern <- '(<a href=.+?\\.xls\">)+?結果表.+?</a>'
xlsList <- regmatches(htmlMarkup, gregexpr(pattern, htmlMarkup, fixed = F))
xlsList
pattern <- '/+?.+?\\.xls'
xlsFile <- gsub('/','',regmatches(xlsList, gregexpr(pattern, xlsList, fixed = F)))
xlsFile
username <- Sys.info()['user']
pathOutput <- paste0("C:/Users/", username, "/Desktop/R_Data_Write/")
setwd(pathOutput)
download.file(paste0('http://www.mlit.go.jp/toukeijouhou/chojou/ex/labor_xls_data/',xlsFile),
              xlsFile, mode = "wb")
buf0 <- readWorksheetFromFile(paste0(pathOutput, xlsFile), sheet = 7, check.names = F, header = F)
colnames(buf0) <- unlist(lapply(paste0(buf0[1,1],'-',buf0[2,]),zen2han))
buf0[,-1] <- apply(buf0[,-1],2,as.numeric)
buf0 <- buf0[-c(1:(which(!is.na(buf0[,2]))[1]-1)),]
rrr <- head(grep('年', buf0[,1]), 1)
yyyy <- as.numeric(substring(buf0[rrr,1], 1, as.numeric(gregexpr('年', buf0[rrr,1])) - 1)) + 1988
mm <- as.numeric(substring(buf0[rrr,1], as.numeric(gregexpr('年', buf0[rrr,1])) + 1))
buf0[,1] <- seq(as.Date(paste0(yyyy,'-',mm,'-1')), by = "1 month", length.out = nrow(buf0))
colnames(buf0)[1] <- 'Date'
assign('laborSupplyAndDemand', buf0)
# csv出力パート
scriptFile <- 'R-writeCSVtoFolder.r'
script <-
  RCurl::getURL(
    paste0("https://raw.githubusercontent.com/am-consulting/am-consulting.github.io/master/",
           scriptFile),
    ssl.verifypeer = F)
eval(parse(text = script))
fun_writeCSVtoFolder(objData = laborSupplyAndDemand,dataType = 1,csvFileName = '建設労働需給調査結果')
# csv出力パート
