# 現在、5つのcsvファイル全てにおいて7列目から時系列データが始まっている。
library(excel.link)
username <- Sys.info()['user']
pathOutput <- paste0("C:/Users/", username, "/Desktop/R_Data_Write/")
setwd(pathOutput)
baseURL <- 'http://www.stat-search.boj.or.jp/ssi/mtshtml/csv/'
csvFile <- c('d.csv','w1.csv','m.csv','q.csv','fy.csv')
for(fff in 1:length(csvFile)){
  download.file(paste0(baseURL,csvFile[fff]), csvFile[fff] , mode = 'wb')
  buf0 <- xl.read.file(paste0(pathOutput, csvFile[fff]), header=F, top.left.cell = "A1", xl.sheet = 1, excel.visible = F)
  colnames(buf0) <- paste0(buf0[3,],'-',buf0[4,],'(',buf0[6,],')')
  buf <- buf0[-c(1:6),]
  buf[,-1] <- apply(buf[,-1],2,as.numeric)
  if(length(grep('\\s',buf[,1]))!=0){
    buf[,1] <- as.Date(unlist(lapply(buf[,1],function(x) substring(x,1, as.numeric(gregexpr('\\s',x)) - 1))))
  }else{
    buf[,1] <- paste0(buf[,1],'-1-1')
  }
  colnames(buf)[1] <- 'Date'
  assign(paste0(csvFile[fff],'_data'), buf, envir = .GlobalEnv)
}
