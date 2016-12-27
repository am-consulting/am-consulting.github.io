# http://www.stat.go.jp/data/kakei/
# http://www.stat.go.jp/data/kakei/sokuhou/tsuki/index.htm
# http://www.stat.go.jp/data/kakei/longtime/index.htm#time
# 家計調査(家計収支編)-1世帯当たり1か月間の支出 -2人以上の世帯
library(XLConnect);library(Nippon);library(lubridate)
username <- Sys.info()['user']
pathOutput <- paste0("C:/Users/", username, "/Desktop/R_Data_Write/")
setwd(pathOutput)
fileName <- 'zenh-n.xls'
download.file(paste0('http://www.stat.go.jp/data/kakei/longtime/zuhyou/', fileName),
              fileName, mode = 'wb')
fun_extract <-
  function(buf0 = buf0){
    tmp <- NA
    for(ccc in 1:ncol(buf0)){
      if(!is.na(buf0[11,ccc])){tmp <- as.numeric(gsub('\\s|\\(|\\)|年','',buf0[11,ccc]))}
      buf0[11,ccc] <- tmp
    }
    tmp <- NA
    for(ccc in 1:ncol(buf0)){
      if(!is.na(buf0[12,ccc])){tmp <- as.numeric(gsub('\\s|月','',buf0[12,ccc]))}
      buf0[12,ccc] <- tmp
    }
    colnames(buf0) <- paste0(buf0[11,],'-',buf0[12,],'-1')
    buf1 <-
      buf0[c(
        which(apply(buf0, 1, function(x) length(grep("^消費支出$",x))) != 0),
        which(apply(buf0, 1, function(x) length(grep("エンゲル係数\\(％\\)",x))) != 0),
        which(apply(buf0, 1, function(x) length(grep("世帯人員\\(人\\)",x))) != 0)
        ),]
    buf2 <- buf1[,-grep('na',colnames(buf1),ignore.case = T)]
    row.names(buf2) <- c('消費支出(円)','エンゲル係数(%)','世帯人員(人)')
    buf3 <- data.frame(colnames(buf2), t(buf2), row.names = NULL, check.names = F, stringsAsFactors = F)
    buf3[,1] <- as.Date(buf3[,1])
    colnames(buf3)[1] <- 'Date'
    buf3[,-1] <- apply(buf3[,-1],2,function(x)as.numeric(gsub(',','',x)))
    return(buf3)
}
buf0 <-
  readWorksheetFromFile(paste0(pathOutput, fileName), sheet = '支出金額（月）', check.names = F, header = F)
assign('expenditure', fun_extract(buf0 = buf0), envir = .GlobalEnv)
buf0 <-
  readWorksheetFromFile(paste0(pathOutput, fileName), sheet = '実質増減率（月）', check.names = F, header = F)
assign('realIncreaseDecreaseRate', fun_extract(buf0 = buf0), envir = .GlobalEnv)
sheetTitle <<- '家計調査(家計収支編):1世帯当たり1か月間の支出:2人以上の世帯'
dfTitle <- c('支出金額(月)','実質増減率(月)')
