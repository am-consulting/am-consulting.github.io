fun_MonthlyLabourSurveyIndices <- function(fileID = 'http://www.e-stat.go.jp/SG1/estat/Xlsdl.do?sinfid=000026271631') {
  # http://www.e-stat.go.jp/SG1/estat/NewList.do?tid=000001011791
  library(XLConnect)
  library(Nippon)
  library(gdata)
  username <- Sys.info()['user']
  pathOutput <-
    paste0("C:/Users/", username, "/Desktop/R_Data_Write/")
  setwd(pathOutput)
  fileNumber <- regmatches(fileID, gregexpr('[0-9]{12}', fileID, fixed = F))
  fileName <- paste0(fileNumber, '.xls')
  download.file(
    fileID,
    fileName,
    mode = "wb"
  )
  buf0 <-
    readWorksheetFromFile(
      paste0(pathOutput, fileName),
      sheet = 1,
      check.names = F,
      header = F
    )
  assign('conditionTable', buf0[1:4, c(1, 6)], envir = .GlobalEnv)
  bufRow1 <- grep('year', buf0[, 1], ignore.case = T)[1]
  bufRow2 <- grep('year', buf0[, 1], ignore.case = T)[2]
  buf1 <- buf0[bufRow1:bufRow2, c(1, grep('月', buf0[bufRow1, ]))]
  buf1[, 1] <- as.numeric(buf1[, 1])
  colnames(buf1)[-1] <- sapply(buf1[1, -1], zen2han)
  buf2 <- buf1[!is.na(buf1[, 1]), ]
  row.names(buf2) <- buf2[, 1]
  buf3 <- buf2[, -1]
  startDate <- as.Date(paste0(row.names(buf3)[1], '-1-1'))
  Value <- as.numeric(as.vector(t(buf3)))
  Date <- seq(startDate, length.out = length(Value), by = 'month')
  buf4 <- na.omit(data.frame(Date, Value, stringsAsFactors = F))
  colnames(buf4)[2] <-
    paste0(sapply(gsub('\\([a-zA-Z].*?\\)', '', conditionTable[, 2]), zen2han), collapse = ':')
  assign(paste0('RealWageIndices-', fileNumber), buf4, envir = .GlobalEnv)
}
