fun_MonthlyLabourSurvey <- function(fileID = '000007913459'){
library(XLConnect)
username <-
  Sys.info()['user']
pathOutput <-
  paste0("C:/Users/", username, "/Desktop/R_Data_Write/")
setwd(pathOutput)
fileName <- paste0(fileID,'.xls')
download.file(url = paste0('http://www.e-stat.go.jp/SG1/estat/GL08020103.do?_xlsDownload_&fileId=',
                           fileID,
                           '&releaseCount=1'),
              destfile = fileName,
              mode = 'wb')
getSheets(loadWorkbook(fileName))
buf0 <-
  readWorksheetFromFile(file = paste0(pathOutput, fileName),
                        sheet = 1,
                        check.names = F,
                        header = F)
sheetDate <- paste0(buf0[2,6],buf0[2,7])
symbolS <-
  read.csv(file = 'https://raw.githubusercontent.com/am-consulting/am-consulting.github.io/master/csv/MonthlyLabourSurveySymbols.csv',
           header = F,quote = "\"",na.strings = c(''),check.names = F,stringsAsFactors = F,fileEncoding = 'utf8')
industries <- list()
objRowS <- grep('産業',gsub('\\s','',buf0[,1]))
objRowE <- c(tail(objRowS,-1)-1,nrow(buf0))
for(iii in seq(length(objRowS))){
  industries[[iii]] <-
    buf0[objRowS[iii]:objRowE[iii],]
  print(head(industries[[iii]],3))
}
industriesName <- vector()
for(iii in seq(length(industries))){
  obj <- industries[[iii]]
  objColumn <- grep('規模',gsub('\\s|\n','',obj[,1]))
  obj[objColumn,] <- gsub('\\s|\n','',obj[objColumn,])
  obj[objColumn+1,] <- gsub('\\s|\n','',obj[objColumn+1,])
  obj[objColumn+2,] <- gsub('\\s|\n','',obj[objColumn+2,])
  obj[objColumn+3,] <- gsub('\\s|\n','',obj[objColumn+3,])
  tmp <- NA
  for(ccc in seq(length(obj))){
    if(!is.na(obj[objColumn,ccc])){tmp <- obj[objColumn,ccc]}
    obj[objColumn,ccc] <- tmp
  }
  tmp <-
    paste0(obj[objColumn,],':',obj[objColumn+1,],':',obj[objColumn+2,],':',obj[objColumn+3,])
  tmp <-
    gsub('NA:パートタイム労働者数','本調査期間末:パートタイム労働者数',tmp)
  colnames(obj) <-
    gsub(':na','',tmp,ignore.case = T)
  industriesName[iii] <-
    paste0(obj[2,1],':',symbolS[grep(obj[2,1],symbolS[,1]),2])
  dataDF <-
    obj[-c(1:(objColumn+3)),]
  dataDF <-
    dataDF[apply(dataDF,1,function(x)sum(is.na(x))!=ncol(dataDF)),]
  dataDF[,-c(1:3)] <-
    apply(dataDF[,-c(1:3)],2,function(x)as.numeric(gsub(',','',x)))
  tmp <- NA
  for(rrr in seq(nrow(dataDF))){
    if(!is.na(dataDF[rrr,1])){tmp <- dataDF[rrr,1]}
    dataDF[rrr,1] <- tmp
  }
  dataDF[is.na(dataDF[,2]),2] <- 'T'
  for(rrr in seq(nrow(dataDF))){
    dataDF[rrr,1] <- paste0(dataDF[rrr,1],':',symbolS[grep(dataDF[rrr,1],symbolS[,3]),4])
    dataDF[rrr,2] <- paste0(dataDF[rrr,2],':',symbolS[grep(dataDF[rrr,2],symbolS[,5]),6])
    dataDF[rrr,3] <- paste0(dataDF[rrr,3],':',symbolS[grep(dataDF[rrr,3],symbolS[,7]),8])
  }
  row.names(dataDF) <- NULL
  assign(paste0('industry',formatC(iii,width = 3,flag = 0)),dataDF,envir = .GlobalEnv)
}
assign('industriesName',industriesName,envir = .GlobalEnv)
}
