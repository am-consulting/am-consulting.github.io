# 全産業活動指数 季節調整済指数
library(XLConnect)
library(Nippon)
library(lubridate)
# csv出力パート
scriptFile <- 'R-writeCSVtoFolder.r'
script <-
  RCurl::getURL(
    paste0("https://raw.githubusercontent.com/am-consulting/am-consulting.github.io/master/",
           scriptFile),
    ssl.verifypeer = F)
eval(parse(text = script))
# csv出力パート
username <- Sys.info()['user']
pathOutput <-
  paste0("C:/Users/", username, "/Desktop/R_Data_Write/")
setwd(pathOutput)
fileName <- c('b2010_zsmj.xls','b2010_zomj.xls')
for(fff in 1:2){
download.file(
  paste0(
    'http://www.meti.go.jp/statistics/tyo/zenkatu/result-2/xls/',
    fileName[fff]
  ),
  fileName[fff],mode = "wb")
buf0 <-
  readWorksheetFromFile(
    paste0(pathOutput, fileName[fff]),
    sheet = 1,
    check.names = F,
    header = F
  )
tableTitle <- zen2han(buf0[1, 1])
buf0[, 2] <- sapply(paste0(buf0[, 2], '(', buf0[, 3], ')'), zen2han)
buf1 <- buf0[-c(1, 2), -c(1, 3)]
buf2 <- t(buf1)
buf2[, 1] <-
  paste0(substring(buf2[, 1], 1, 4), '-', substring(buf2[, 1], 5, 6), '-01')
colnames(buf2) <- sapply(gsub('\\s', '', buf2[1, ]), zen2han)
buf2 <- buf2[-1, ]
tmp <- buf2[, 1]
buf2[, 1] <- as.Date(buf2[, 1])
buf2[, 1] <- tmp
colnames(buf2)[1] <- 'Date'
buf3 <- as.data.frame(buf2, stringsAsFactors = F)
buf3[, -1] <- apply(buf3[, -1], 2, function(x)
  as.numeric(x))
buf3[, 1] <- as.Date(buf3[, 1])
class(buf3[, 1])
colnames(buf3)
if(fff==1){colnames(buf3)[-1] <- paste0(colnames(buf3)[-1],':季節調整値')}
if(fff==2){colnames(buf3)[-1] <- paste0(colnames(buf3)[-1],':原数値')}
switch(fff,
       assign('allIndustryActivity',buf3),
       assign('allIndustryActivityNSA',buf3))
}
# csv出力パート
fun_writeCSVtoFolder(objData = allIndustryActivity,dataType = 1,csvFileName = '全産業活動指数_季節調整値')
fun_writeCSVtoFolder(objData = allIndustryActivityNSA,dataType = 1,csvFileName = '全産業活動指数_原数値')
# csv出力パート
