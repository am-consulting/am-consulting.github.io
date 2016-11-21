# ―,ソ,噂,欺,圭,構,蚕,十,申,貼,能,表,暴,予,禄,兔
library(XLConnect)
library(Nippon)
library(lubridate)
username <- Sys.info()['user']
pathOutput <- paste0("C:/Users/", username, "/Desktop/R_Data_Write/")
setwd(pathOutput)
urlToData <- 'https://www.boj.or.jp/research/research_data/reri/'
fileName <- 'reri'
if(!file.exists(paste0(pathOutput, 'Data.xls'))) {
  download.file(paste0(urlToData, fileName, '.zip'), paste0(fileName, '.zip'), mode = 'wb')
  unzip(paste0(fileName,'.zip'))
}
# sheet1
buf0 <-
  readWorksheetFromFile(paste0(pathOutput, 'Data.xls'), sheet = 1, check.names = F, header = F)
colnames(buf0) <- unlist(lapply(paste0(buf0[1,],'-',buf0[2,]),zen2han))
buf0 <- buf0[-c(1:4),]
tmp0 <- which(apply(buf0,2,function(x){sum(is.na(x))})==nrow(buf0))
tmp1 <- length(tmp0)
if(tmp1!=0){
  buf0 <- buf0[,-tmp0]
}
colnames(buf0)[1] <- 'Date'
buf0[,-1] <- apply(buf0[,-1],2,as.numeric)
buf0[,1] <- as.Date(buf0[,1],tz = 'Asia/Tokyo')
RealExportsAndRealImports01 <- buf0
# sheet1
# sheet2
buf0 <-
  readWorksheetFromFile(paste0(pathOutput, 'Data.xls'), sheet = 2, check.names = F, header = F)
ccc <- grep('その他',buf0[2,])[1]
buf0[2,ccc] <- paste0(buf0[2,ccc],'国･地域')
colnames(buf0) <- unlist(lapply(paste0(buf0[1,],'-',buf0[2,],'-',buf0[3,]),zen2han))
buf0 <- buf0[-c(1:6),]
tmp0 <- which(apply(buf0,2,function(x){sum(is.na(x))})==nrow(buf0))
tmp1 <- length(tmp0)
if(tmp1!=0){
  buf0 <- buf0[,-tmp0]
}
colnames(buf0)[1] <- 'Date'
buf0[,-1] <- apply(buf0[,-1],2,as.numeric)
buf0[,1] <- as.Date(buf0[,1],tz = 'Asia/Tokyo')
colnames(buf0) <- gsub('NA-','',colnames(buf0))
RealExportsAndRealImports02 <- buf0
# sheet2
allData <- merge(RealExportsAndRealImports01,RealExportsAndRealImports02,by = 'Date',all = T)
write.table(allData, "clipboard", sep = "\t", row.names = F, col.names = T)