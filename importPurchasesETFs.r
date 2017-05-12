library(XLConnect);library(Nippon)
username <-
  Sys.info()['user']
pathOutput <-
  paste0("C:/Users/", username, "/Desktop/R_Data_Write/")
setwd(pathOutput)
urlToData <-
  'http://www3.boj.or.jp/market/jp/etfreit.zip'
fileName <-
  gsub('.+/([^/]+)','\\1',urlToData)
download.file(url = urlToData,destfile = fileName, mode = 'wb')
unzip(fileName)
xlsFile <- dir(pathOutput)[grep('\\.xls',dir(pathOutput))]
buf0 <-
  readWorksheetFromFile(paste0(pathOutput,xlsFile), sheet = 1, check.names = F, header = F)
buf1 <- buf0
sheetUnit <- zen2han(buf1[5,4])
keyWord <- '約定日'
objRow <- which(apply(buf1,1,function(x)(length(grep(keyWord,x))))!=0)
objCol <- which(apply(buf1,2,function(x)(length(grep(keyWord,x))))!=0)
buf2 <- buf1[-c(1:(objRow-1)),]
row.names(buf2) <- NULL
buf3 <- buf2[-c(2,4),]
tnmp <- NA
for(ccc in 1:ncol(buf3)){
  if(!is.na(buf3[1,ccc])){tmp <- buf3[1,ccc]}
  buf3[1,ccc] <- tmp
}
colnames(buf3) <-
  sapply(gsub('\\s','',gsub('(.+)\n.+','\\1',paste0(buf3[1,],':',buf3[2,]))),zen2han)
buf4 <- buf3[-c(1,2),]
buf4[,1] <- as.Date(buf4[,1])
colnames(buf4)[-1] <- paste0(colnames(buf4)[-1],sheetUnit)
buf4[,-1] <- data.frame(apply(buf4[,-1],2,as.numeric),check.names = F,stringsAsFactors = F)
PurchasesETFs <- buf4
# csv出力パート
scriptFile <- 'R-writeCSVtoFolder.r'
script <-
  RCurl::getURL(
    paste0("https://raw.githubusercontent.com/am-consulting/am-consulting.github.io/master/",
           scriptFile),
    ssl.verifypeer = F)
eval(parse(text = script))
fun_writeCSVtoFolder(objData = PurchasesETFs,dataType = 1,csvFileName = 'ETFJ-REITの買入結果')
# csv出力パート
