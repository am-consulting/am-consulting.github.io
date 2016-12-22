# Source 日本政府観光局 http://www.jnto.go.jp/jpn/statistics/visitor_trends/index.html
library(XLConnect);library(plyr)
rbind.fill
username <- Sys.info()['user']
pathOutput <- paste0("C:/Users/", username, "/Desktop/R_Data_Write/")
setwd(pathOutput)
fileName <- 'since2003_tourists.xls'
if(!file.exists(paste0(pathOutput, fileName))) {
  download.file(paste0('http://www.jnto.go.jp/jpn/statistics/',fileName),
                fileName, mode = "wb")
}
cnt <- 0
for(yyyy in 2003:2016){
  buf0 <-
    readWorksheetFromFile(paste0(pathOutput, fileName), sheet = as.character(yyyy), check.names = F, header = F)
  cnt <- cnt + 1
  bufTitle <- buf0[1,1]
  buf1 <- buf0[,c(1,grep('[0-9]月',buf0[4,]))]
  buf1 <- buf1[-grep('注', buf1[,1]),]
  buf2 <- t(buf1[c(4:nrow(buf1)),c(1:ncol(buf1))])
  colnames(buf2) <- buf2[1,]
  buf2 <- buf2[-1,]
  buf2[,1] <- paste0(substring(bufTitle,1,4),'-',gsub('月','',buf2[,1]),'-1')
  colnames(buf2)[1] <- 'Date'
  row.names(buf2) <- NULL
  buf2[,-1] <- apply(buf2[,-1],2,function(x)as.numeric(gsub(',','',x)))
  buf3 <- as.data.frame(buf2)
  buf3 <- buf3[which(apply(buf3,1,function(x)sum(is.na(x)))!=(ncol(buf3)-1)),]
  if(cnt == 1){
    numberOfForeignVisitorsToJapan <- buf3
  }else{
    numberOfForeignVisitorsToJapan <- rbind.fill(numberOfForeignVisitorsToJapan,buf3)
  }
}
numberOfForeignVisitorsToJapan[,1] <- as.Date(numberOfForeignVisitorsToJapan[,1])
numberOfForeignVisitorsToJapan[,-1] <- apply(numberOfForeignVisitorsToJapan[,-1],2,as.numeric)
class(numberOfForeignVisitorsToJapan[,1])
class(numberOfForeignVisitorsToJapan[,ncol(numberOfForeignVisitorsToJapan)])
