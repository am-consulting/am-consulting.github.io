# http://www.stat.go.jp/data/joukyou/12.htm
library(XLConnect);library(Nippon)
username <-
  Sys.info()['user']
pathOutput <-
  paste0("C:/Users/", username, "/Desktop/R_Data_Write/")
setwd(pathOutput)
baseURL <-
  'http://www.stat.go.jp/data/joukyou/zuhyou/'
fileName <-
  'tskh27-m.xls'
sheetNo <-
  4
download.file(paste0(baseURL, fileName), fileName, mode = 'wb')
buf0 <-
  readWorksheetFromFile(paste0(pathOutput, fileName), sheet = sheetNo, check.names = F, header = F)
sheetTitle <-
  gsub('\\s','',zen2han(paste0(buf0[1,1], ':', buf0[2,1])))
tmp <- NA
for(ccc in 1:ncol(buf0)){
  if(!is.na(buf0[5,ccc])){tmp <- buf0[5,ccc]}
  buf0[5,ccc] <- tmp
}
buf0[5,] <-
  as.numeric(gsub('平成|年','',buf0[5,])) + 1988
buf0[6,] <-
  as.numeric(gsub('月','',buf0[6,]))
buf0[8,] <-
  paste0(buf0[5,],'-',buf0[6,],'-1')
buf1 <- buf0[-c(1:7),]
buf2 <-
  buf1[-which((ncol(buf1)-1) <= apply(buf1,1,function(x)sum(is.na(x)))),]
buf2[,1] <-
  gsub('\\s','',sapply(buf2[,1],zen2han))
buf3 <-
  t(buf2)
colnames(buf3) <- (buf3[1,])
buf3 <- buf3[-1,]
buf3[,-1] <-
  apply(buf3[,-1],2,function(x)as.numeric(gsub(',','',x)))
buf4 <-
  data.frame(Date = as.Date(buf3[,1]),buf3[,-1],row.names = NULL ,check.names = F,stringsAsFactors = F)
objColumn <- c(1:7,52:ncol(buf4))
colnames(buf4)[-objColumn] <-
  paste0(substring(colnames(buf4)[-objColumn],1,2),':',substring(colnames(buf4)[-objColumn],3))
assign('ExpenditureOnGoodsAndServices', buf4, envir = .GlobalEnv)
