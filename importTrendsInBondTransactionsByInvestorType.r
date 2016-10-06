library(XLConnect)
username <- Sys.info()['user']
pathOutput <-
  paste("C:/Users/", username, "/Desktop/R_Data_Write/", sep = "")
setwd(pathOutput)
fileName <- 'koushasaiichiran.xls'
if(!file.exists(paste0(pathOutput, fileName))) {
  download.file(paste0('http://www.jsda.or.jp/shiryo/toukei/toushika/tkb/files/', fileName), fileName, mode = "wb")
}
buf <-
  XLConnect::readWorksheetFromFile(
    paste0(pathOutput, fileName),
    sheet = 1   ,
    check.names = F,
    header = F
  )
dataTitle <<-  buf[1, which(!is.na(buf[1, ]))]
bufStrings <- substr(unlist(buf[3, ]), 1, regexpr('\n', unlist(buf[3, ])) - 1)
buf[3, ] <- bufStrings
bufStrings <- substr(unlist(buf[4, ]), 1, regexpr('\n', unlist(buf[4, ])) - 1)
buf[4, ] <- bufStrings
buf1 <- buf[, which(!((nrow(buf) - 10) <= apply(buf, 2, function(x){sum(is.na(x))}))), drop = F]
for (ccc in 1:length(buf1[3, ])) {
  if (is.na(buf1[3, ccc])) {
    buf1[3, ccc] <- buf1[3, ccc - 1]
  }
}
colnames(buf1) <- paste0(buf1[3, ], ':', buf1[4, ])
buf1 <- na.omit(buf1[-(1:4), ])
buf1[, -1] <- apply(buf1[, -1], 2, function(x) {as.numeric(gsub(',', '', x))})
buf1[, 1] <- as.Date(paste0(gsub('\\.','-',buf1[,1]),'-1'))
assign('dataSet_BondTransactions', buf1, envir = .GlobalEnv)