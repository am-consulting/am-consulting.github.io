# ―,ソ,噂,欺,圭,構,蚕,十,申,貼,能,表,暴,予,禄,兔
library(XLConnect)
library(Nippon)
library(lubridate)
username <- Sys.info()['user']
pathOutput <- paste0("C:/Users/", username, "/Desktop/R_Data_Write/")
setwd(pathOutput)
dataType <- '季節調整値(seasonally adjusted) '
fileName <- 'shouhi2.xls'
if(!file.exists(paste0(pathOutput, fileName))) {
  download.file(paste0('http://www.esri.cao.go.jp/jp/stat/shouhi/timeseries/',fileName), fileName, mode = "wb")
}
buf0 <- readWorksheetFromFile(paste0(pathOutput, fileName), sheet = dataType, check.names = F, header = F)
buf1 <- buf0
buf2 <- buf1[!is.na(buf1[,3]),]
datatitle <- buf1[2,1]
tmp0 <- ''
for(ccc in 1:ncol(buf1)){
  if(!is.na(buf1[5,ccc])){tmp0 <- buf1[5,ccc]}
  buf1[5,ccc] <- tmp0
  if(!is.na(buf1[7,ccc])){tmp <- paste0(tmp0,'-',buf1[7,ccc]);buf1[5,ccc] <- tmp}
}
colnames(buf2) <- gsub('\n','',buf1[5,])
buf3 <- buf2[,-grep('前月差',buf1[9,])]
yyyy <- as.numeric(substring(buf3[tail(grep('年',buf3[,2]),1),2],1,2))+1988
buf3[,3] <- unlist(lapply(buf3[,3],zen2han))
buf3[,1] <- rev(as.Date(paste0(yyyy,'-',tail(buf3[,3],1),'-1')) %m-% months(c(0:(nrow(buf3)-1))))
buf4 <- subset(buf3,as.Date('2004-4-1')<=buf3[,1])[,-(2:5)]
colnames(buf4)[1] <- 'Date'
buf4[,-1] <- apply(buf4[,-1],2,as.numeric)
buf5 <- buf4[,colSums(is.na(buf4))!=nrow(buf4)]
consumerConfidenceIndex <- buf5
# csv出力パート
scriptFile <- 'R-writeCSVtoFolder.r'
script <-
  RCurl::getURL(
    paste0("https://raw.githubusercontent.com/am-consulting/am-consulting.github.io/master/",
           scriptFile),
    ssl.verifypeer = F)
eval(parse(text = script))
fun_writeCSVtoFolder(objData = consumerConfidenceIndex,dataType = 1,csvFileName = 'consumerConfidenceIndex')
# csv出力パート
