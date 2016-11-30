# http://www.mlit.go.jp/sogoseisaku/jouhouka/sosei_jouhouka_tk4_000112.html
library(XLConnect);library(Nippon)
username <- Sys.info()['user']
pathOutput <- paste0("C:/Users/", username, "/Desktop/R_Data_Write/")
setwd(pathOutput)
fileName <- '001150301.xls'
fileURL <- 'http://www.mlit.go.jp/common/'
if(!file.exists(paste0(pathOutput, fileName))) {
  download.file(paste0(fileURL,fileName), fileName, mode = "wb")
}
buf0 <- readWorksheetFromFile(paste0(pathOutput, fileName), sheet = 1, check.names = F, header = F)
buf <- buf0
rrS <- grep('月別', gsub('\\s','',buf[,1])) + 1
ccS <- grep('在来', gsub('\\s','',buf[5,]))[1]
buf[1,] <- gsub('\\s','',zen2han(buf[1,3]))
colnames(buf) <-
  gsub('-NA|・|\\s','',unlist(lapply(apply(buf[c(1,4:6),],2,function(x)paste0(x,collapse = '-')),zen2han)))
buf1 <- buf[rrS:nrow(buf),c(1,2,ccS:ncol(buf))]
buf1[,1] <- as.numeric(gsub('年','',buf1[,1]))
buf1[,2] <- as.numeric(gsub('月','',buf1[,2]))
tmp <- NA
for(rrr in 1:nrow(buf1)){
  if(!is.na(buf1[rrr,1])){tmp <- buf1[rrr,1]}
  buf1[rrr,1] <- tmp
}
buf1[,1] <- as.Date(paste0(buf1[,1],'-',buf1[,2],'-1'))
buf1 <- na.omit(buf1[,-2])
colnames(buf1)[1] <- 'Date'
buf1[,-1] <- apply(buf1[,-1],2,as.numeric)
assign('ConstructionCostDeflator', buf1, envir = .GlobalEnv)
