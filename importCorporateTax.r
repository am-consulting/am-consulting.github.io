# ―,ソ,噂,欺,圭,構,蚕,十,申,貼,能,表,暴,予,禄,兔
# 法人税
library(XLConnect)
library(Nippon)
library(lubridate)
username <- Sys.info()['user']
pathOutput <- paste0("C:/Users/", username, "/Desktop/R_Data_Write/")
setwd(pathOutput)
fileName <- '03.xls'
if(!file.exists(paste0(pathOutput, fileName))) {
  download.file(paste0('https://www.nta.go.jp/kohyo/tokei/kokuzeicho/jikeiretsu/xls/',fileName), fileName, mode = "wb")
}
buf0 <- readWorksheetFromFile(paste0(pathOutput, fileName), sheet = 1, check.names = F, header = F)
buf1 <- buf0
tmp <- NA
rrr <- 7
for(ccc in 1:ncol(buf1)){
  if(!is.na(buf1[rrr,ccc])){tmp <- buf1[rrr,ccc]}
  buf1[rrr,ccc] <- gsub('\\s','',tmp)
}
tmp <- NA
rrr <- 8
for(ccc in 1:ncol(buf1)){
  if(!is.na(buf1[rrr,ccc])){tmp <- buf1[rrr,ccc]}
  buf1[rrr,ccc] <- gsub('\\s','',tmp)
}
tmp <- NA
rrr <- 9
for(ccc in 1:ncol(buf1)){
  if(!is.na(buf1[rrr,ccc])){tmp <- buf1[rrr,ccc]}
  if(!is.na(buf1[rrr-1,ccc])){
    if(buf1[rrr-1,ccc]==buf1[rrr-1,3]){
      buf1[rrr,ccc] <- gsub('\\s','',tmp)
    }
  }
}
colnames(buf1) <- gsub('\\s','',paste0(buf1[7,],'-',buf1[8,],'-',buf1[9,],'-',buf1[10,],'(',buf1[11,],')'))
colnames(buf1) <- gsub('-NA|\\(NA\\)','',colnames(buf1))
buf2 <- buf1[-c(1:11),]
buf3 <- buf2[-which(is.na(buf2[,3])),]
heisei <- grep('平成元',buf3[,1])
buf3[heisei,1] <- 1
buf3[,1] <- gsub('昭和|年分|平成','',buf3[,1])
buf3[heisei:nrow(buf3),1] <- as.numeric(unlist(lapply(buf3[heisei:nrow(buf3),1],zen2han))) + 1988
buf3[1:(heisei-1),1] <- as.numeric(unlist(lapply(buf3[1:(heisei-1),1],zen2han))) + 1925
buf3[,1] <- as.numeric(buf3[,1])
diff(buf3[,1])
buf3[,1] <- as.Date(paste0(buf3[,1],'-12-31'))
colnames(buf3)[1] <- 'Date'
buf4 <- buf3[,-c(2,15,ncol(buf3))]
buf4[,-1] <- apply(buf4[,-1],2,function(x) as.numeric(gsub(',|\\s|－','',x)))
colnames(buf4)[-1] <- paste0('法人税-',colnames(buf4)[-1])
# 単位変換
buf4[,-1] <- apply(buf4[,-1],2,function(x){x*10^-6})
colnames(buf4)[-1] <- gsub('百万','兆',colnames(buf4)[-1])
# 単位変換
assign('corporateTax',buf4,envir = .GlobalEnv)
write.csv(corporateTax,paste0('check_',gsub('xls','csv',fileName)),row.names = F)
