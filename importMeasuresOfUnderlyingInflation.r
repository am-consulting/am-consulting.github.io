# ―,ソ,噂,欺,圭,構,蚕,十,申,貼,能,表,暴,予,禄,兔
library(XLConnect)
library(Nippon)
library(lubridate)
username <- Sys.info()['user']
pathOutput <- paste0("C:/Users/", username, "/Desktop/R_Data_Write/")
setwd(pathOutput)
urlToData <- 'https://www.boj.or.jp/research/research_data/cpi/'
fileName <- 'cpirev'
if(!file.exists(paste0(pathOutput, 'Data.xls'))) {
  download.file(paste0(urlToData, fileName, '.zip'), paste0(fileName, '.zip'), mode = 'wb')
  unzip(paste0(fileName,'.zip'))
}
buf0 <-
  readWorksheetFromFile(paste0(pathOutput, 'Data.xls'), sheet = 1, check.names = F, header = F)
colnames(buf0) <- unlist(lapply(paste0(buf0[2,],'-',buf0[3,]),zen2han))
buf0 <- buf0[-c(1:5),]
buf0 <- buf0[,-(which(apply(buf0,2,function(x){sum(is.na(x))})==nrow(buf0)))]
colnames(buf0)[1] <- 'Date'
buf0[,-1] <- apply(buf0[,-1],2,as.numeric)
buf0[,1] <- as.Date(paste0(substring(buf0[,1],1,4),'-',substring(buf0[,1],6,7),'-',substring(buf0[,1],9,10)))
measuresOfUnderlyingInflation <- buf0