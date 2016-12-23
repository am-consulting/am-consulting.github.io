library(XLConnect);library(Nippon)
username <- Sys.info()['user']
pathOutput <- paste0("C:/Users/", username, "/Desktop/R_Data_Write/")
setwd(pathOutput)
fileName <- 'histn21601.xlsx'
download.file(paste0('https://www.shiruporuto.jp/finance/chosa/yoron2016fut/pdf/',fileName),
              fileName, mode = "wb")
# 金融資産の有無
buf0 <-
  readWorksheetFromFile(paste0(pathOutput, fileName), sheet = 3, check.names = F, header = F)
sheetTitle <- zen2han(buf0[1,1])
buf1 <- buf0[apply(buf0,1,function(x)sum(is.na(x)))!=ncol(buf0),]
tmp <- NA
for(ccc in 1:ncol(buf1)){
 if(!is.na(buf1[2,ccc])){tmp <- buf1[2,ccc]}
  buf1[2,ccc] <- tmp
}
colnames(buf1) <- gsub('\n','',sapply(paste0(buf1[2,],':',buf1[3,],'(',buf1[5,],')'),zen2han))
buf1[,1] <- as.numeric(gsub('年','',buf1[,1]))
buf2 <- buf1[!is.na(buf1[,1]),]
buf2[,1] <- paste0(buf2[,1],'-1-1')
colnames(buf2)[1] <- 'Date'
buf2[,-1] <- apply(buf2[,-1],2,as.numeric)
buf2[,1] <- as.Date(buf2[,1])
assign('presenceORabsence',buf2,envir = .GlobalEnv)
assign('presenceORabsenceTitle',sheetTitle,envir = .GlobalEnv)
# 金融資産保有額
buf0 <-
  readWorksheetFromFile(paste0(pathOutput, fileName), sheet = 4, check.names = F, header = F)
sheetTitle <- zen2han(buf0[1,1])
buf1 <- buf0[apply(buf0,1,function(x)sum(is.na(x)))!=ncol(buf0),]
tmp <- NA
for(ccc in 1:ncol(buf1)){
 if(!is.na(buf1[6,ccc])){tmp <- buf1[6,ccc]}
  buf1[6,ccc] <- tmp
}
colnames(buf1) <- gsub('\n|NA','',sapply(paste0(buf1[2,],buf1[3,],buf1[4,],buf1[5,],'(',buf1[6,],')'),zen2han))
buf1[,1] <- as.numeric(gsub('年','',buf1[,1]))
buf2 <- buf1[!is.na(buf1[,1]),]
buf2[,1] <- paste0(buf2[,1],'-1-1')
colnames(buf2)[1] <- 'Date'
buf2 <- buf2[,!is.na(buf2[nrow(buf2),])]
buf2[,-1] <- apply(buf2[,-1],2,function(x)as.numeric(gsub(',','',x)))
buf2[,1] <- as.Date(buf2[,1])
assign('holdings',buf2,envir = .GlobalEnv)
assign('holdingsTitle',sheetTitle,envir = .GlobalEnv)
