# ―,ソ,噂,欺,圭,構,蚕,十,申,貼,能,表,暴,予,禄,兔
# 日本銀行 マネタリーベース
library(XLConnect)
library(Nippon)
library(lubridate)
username <- Sys.info()['user']
pathOutput <- paste0("C:/Users/", username, "/Desktop/R_Data_Write/")
setwd(pathOutput)
urlToData <- 'http://www.boj.or.jp/statistics/boj/other/mb/'
fileName <- 'mblong'
if(!file.exists(paste0(pathOutput, fileName, '.xls'))) {
  download.file(paste0(urlToData, fileName, '.zip'), paste0(fileName, '.zip'), mode = 'wb')
  unzip(paste0(fileName,'.zip'))
}
buf0 <-
  readWorksheetFromFile(paste0(pathOutput, fileName, '.xls'), sheet = 1, check.names = F, header = F)
for(rrr in 1:nrow(buf0)){
  if(!is.na(as.numeric(substring(buf0[rrr,1],1,4)))){break}
}
dataName <- zen2han(buf0[2,1])

for(cccc in 2:ncol(buf0)){
  for(rrrr in 1:nrow(buf0)){
    tmp <- buf0[rrrr,cccc]
    if(!is.na(tmp)){
      if(length(grep('単位', tmp)) == 0 & length(grep('unit', tmp, ignore.case = T)) == 0){
        buf0[rrr-1,cccc] <- tmp;break
      }
    }
  }
}
buf0[rrr-1,1] <- 'Date'
colnames(buf0) <- buf0[rrr-1,]
buf <- buf0[-c(1:(rrr-1)),]
for(rrr in 1:nrow(buf)){
  tmp <- buf[rrr,1]
  if(length(grep('/',tmp)) != 0){
    buf[rrr,1] <- paste0(substring(tmp,1,4),'-',substring(tmp,6),'-1')
  }
}
buf[,1] <- as.Date(buf[,1])
colnames(buf) <- gsub(' ','',gsub('　　','',gsub('\n','',colnames(buf))))
for(ccc in 1:ncol(buf)){
  colnames(buf)[ccc] <- zen2han(colnames(buf)[ccc])
}
colnames(buf)[-1] <- paste0(dataName,'-',colnames(buf)[-1])
buf[,-1] <- apply(buf[,-1],2,function(x) as.numeric(gsub(',','',x)))
monetaryBase_Japan <- buf
# 日本銀行 マネタリーベース