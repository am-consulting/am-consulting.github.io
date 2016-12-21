# 全産業活動指数 季節調整済指数
library(XLConnect)
library(Nippon)
library(lubridate)
username <- Sys.info()['user']
pathOutput <-
  paste0("C:/Users/", username, "/Desktop/R_Data_Write/")
setwd(pathOutput)
fileName <- 'b2010_zsmj.xls'
if (!file.exists(paste0(pathOutput, fileName))) {
  download.file(
    paste0(
      'http://www.meti.go.jp/statistics/tyo/zenkatu/result-2/xls/',
      fileName
    ),
    fileName,
    mode = "wb"
  )
}
buf0 <-
  readWorksheetFromFile(
    paste0(pathOutput, fileName),
    sheet = 1,
    check.names = F,
    header = F
  )
tableTitle <- zen2han(buf0[1, 1])
buf0[, 2] <- sapply(paste0(buf0[, 2], '(', buf0[, 3], ')'), zen2han)
buf1 <- buf0[-c(1, 2), -c(1, 3)]
buf2 <- t(buf1)
buf2[, 1] <-
  paste0(substring(buf2[, 1], 1, 4), '-', substring(buf2[, 1], 5, 6), '-01')
colnames(buf2) <- sapply(gsub('\\s', '', buf2[1, ]), zen2han)
buf2 <- buf2[-1, ]
tmp <- buf2[, 1]
buf2[, 1] <- as.Date(buf2[, 1])
buf2[, 1] <- tmp
colnames(buf2)[1] <- 'Date'
buf3 <- as.data.frame(buf2, stringsAsFactors = F)
buf3[, -1] <- apply(buf3[, -1], 2, function(x)
  as.numeric(x))
allIndustryActivity <- buf3
allIndustryActivity[, 1] <- as.Date(allIndustryActivity[, 1])
class(allIndustryActivity[, 1])
colnames(allIndustryActivity)
