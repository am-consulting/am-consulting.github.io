# ―,ソ,噂,欺,圭,構,蚕,十,申,貼,能,表,暴,予,禄,兔
library(XLConnect)
library(Nippon)
library(lubridate)
username <- Sys.info()['user']
pathOutput <- paste0("C:/Users/", username, "/Desktop/R_Data_Write/")
setwd(pathOutput)
urlToData <- 'https://www.boj.or.jp/research/research_data/gap/'
fileName <- 'gap'
if(!file.exists(paste0(pathOutput, 'Data.xls'))) {
  download.file(paste0(urlToData, fileName, '.zip'), paste0(fileName, '.zip'), mode = 'wb')
  unzip(paste0(fileName,'.zip'))
}
buf0 <-
  readWorksheetFromFile(paste0(pathOutput, 'Data.xls'), sheet = 1, check.names = F, header = F)
colnames(buf0) <- paste0(buf0[2,],'(',buf0[4,],')')
buf0 <- buf0[-c(1:5),]
tmp0 <- which(apply(buf0,2,function(x){sum(is.na(x))})==nrow(buf0))
tmp1 <- length(tmp0)
if(tmp1!=0){
  buf0 <- buf0[,-tmp0]
}
colnames(buf0)[1] <- 'Date'
buf0[,-1] <- apply(buf0[,-1],2,as.numeric)
buf0[,1] <- as.yearqtr(gsub('Q','',gsub('\\.','-',buf0[,1])))
colnames(buf0) <- unlist(lapply(colnames(buf0),zen2han))
OutputGapAndPotentialGrowthRate <- buf0
write.table(OutputGapAndPotentialGrowthRate, "clipboard-16384", sep = "\t", row.names = F, col.names = T, quote = F)