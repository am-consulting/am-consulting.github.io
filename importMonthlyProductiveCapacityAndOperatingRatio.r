# 製造工業生産能力・稼働率指数 季節調整済指数
# importMonthlyProductiveCapacityAndOperatingRatio.r
library(XLConnect);library(Nippon);library(lubridate);library(excel.link)
username <- Sys.info()['user']
pathOutput <- paste0("C:/Users/", username, "/Desktop/R_Data_Write/")
setwd(pathOutput)
fileName <- 'b2010_ngsm1j.xls'
if(!file.exists(paste0(pathOutput, fileName))) {
  download.file(paste0('http://www.meti.go.jp/statistics/tyo/iip/xls/',fileName), fileName, mode = "wb")
}
buf0 <- readWorksheetFromFile(paste0(pathOutput, fileName), sheet = 1, check.names = F, header = F)
tableTitle <- zen2han(buf0[1,1])
buf0[,2] <- sapply(paste0(buf0[,2],'(',buf0[,3],')'),zen2han)
buf1 <- buf0[-c(1,2),-c(1,3)]
buf2 <- t(buf1)
buf2[,1] <- paste0(substring(buf2[,1],1,4),'-',substring(buf2[,1],5,6),'-01')
colnames(buf2) <- buf2[1,]
buf2 <- buf2[-1,]
tmp <- buf2[,1]
buf2[,1] <- as.Date(buf2[,1])
buf2[,1] <- tmp
colnames(buf2)[1] <- 'Date'
buf3 <- as.data.frame(buf2,stringsAsFactors = F)
buf3[,-1] <- apply(buf3[,-1],2,function(x)as.numeric(x))
MonthlyProductiveCapacityAndOperatingRatio <- buf3
MonthlyProductiveCapacityAndOperatingRatio[,1] <- as.Date(MonthlyProductiveCapacityAndOperatingRatio[,1])
class(MonthlyProductiveCapacityAndOperatingRatio[,1])
colnames(MonthlyProductiveCapacityAndOperatingRatio)[-1] <-
  paste0(colnames(MonthlyProductiveCapacityAndOperatingRatio)[-1],':製造工業生産能力･稼働率指数･SA')
# csv出力パート
scriptFile <- 'R-writeCSVtoFolder.r'
script <-
  RCurl::getURL(
    paste0("https://raw.githubusercontent.com/am-consulting/am-consulting.github.io/master/",
           scriptFile),
    ssl.verifypeer = F)
eval(parse(text = script))
fun_writeCSVtoFolder(objData = MonthlyProductiveCapacityAndOperatingRatio,dataType = 1,
                     csvFileName = '製造工業生産能力_稼働率指数_SA')
# csv出力パート
