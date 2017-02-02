# 日本銀行 基調的なインフレ率を捕捉するための指標 2017年
library(Nippon);library(XLConnect)
username <-
  Sys.info()['user']
pathOutput <-
  paste0("C:/Users/", username, "/Desktop/R_Data_Write/")
setwd(pathOutput)
urlToData <-
  'http://www.boj.or.jp/research/research_data/cpi/'
fileName <-
  'cpirev.xlsx'
download.file(paste0(urlToData, fileName), fileName, mode = 'wb')
buf0 <-
  readWorksheetFromFile(paste0(pathOutput, fileName), sheet = 1, check.names = F, header = F)
colnames(buf0) <-
  unlist(lapply(paste0(buf0[2,],':',buf0[3,]),zen2han))
buf0 <-
  buf0[-c(1:5),]
buf0 <-
  buf0[,-(which(apply(buf0,2,function(x){sum(is.na(x))}) == nrow(buf0)))]
colnames(buf0)[1] <-
  'Date'
buf0[,-1] <-
  apply(buf0[,-1],2,as.numeric)
buf0[,1] <-
  as.Date(paste0(substring(buf0[,1],1,4),
                 '-',
                 substring(buf0[,1],6,7),
                 '-1'))
# as.Date(buf0[,1])では1日分ズレる(POSIXct)
measuresOfUnderlyingInflation <- buf0
