# http://www.boj.or.jp/statistics/boj/fm/ope/m_release/2013/index.htm/
# （注）2013年6月分から、ZIP形式の圧縮ファイルの掲載に変更しました。
fun_bojOperationHistory <- function(startYear = 2016, stopYear = 2016, stopMonth = 99){
  library(XLConnect);library(Nippon);library(lubridate)
  username <- Sys.info()['user']
  pathOutput <- paste0("C:/Users/", username, "/Desktop/R_Data_Write/")
  setwd(pathOutput)
  cnt <- 0
  for(yyyy in startYear:stopYear){
    for(mm in 1:12){
      if(yyyy == 2013 & mm < 6){break}
      if(yyyy == stopYear & stopMonth < mm){break}
      fileName <-
        paste0('ope', substring(yyyy, 3, 4), formatC(mm, flag = '0', width = 2))
      download.file(paste0('http://www.boj.or.jp/statistics/boj/fm/ope/m_release/', yyyy, '/', fileName, '.zip'),
                    paste0(fileName, '.zip'),
                    mode = 'wb')
      unzip(paste0(fileName, '.zip'))
      buf0 <-
        readWorksheetFromFile(paste0(pathOutput, paste0(fileName, '.xls')), sheet = 2, check.names = F, header = F)
      cnt <- cnt + 1
      # 整形パート
      bufRow <-
        which(apply(buf0, 1, function(x){(length(grep('実行日', x)))}) != 0)
      colnames(buf0) <- gsub('\\W', '', buf0[bufRow,])
      buf1 <- buf0[-c(1:bufRow),]
      bufColumn <- which(colnames(buf1) == '種類')
      buf2 <- buf1[!is.na(buf1[,bufColumn]),]
      yyyybuf <- unique(year(buf2[,1]))
      mmbuf <- unique(month(buf2[,1]))
      bufColumn <- which(colnames(buf2) == '落札額')
      buf2[,bufColumn] <- as.numeric(gsub(',', '', buf2[, bufColumn]))
      attach(buf2)
      opeTable <- cbind(by(buf2[,bufColumn], `種類`, sum))
      opeTable <-
        data.frame(row.names(opeTable), opeTable, check.names = F, stringsAsFactors = F, row.names = NULL)
      opeTable[,1] <- sapply(opeTable[,1],zen2han)
      colnames(opeTable) <-
        c('種類/落札額(億円)', paste0(yyyybuf, '年', mmbuf, '月'))
      if(cnt == 1){
        totalOpeTable <- opeTable
      }else{
        totalOpeTable <- merge(totalOpeTable, opeTable, by = '種類/落札額(億円)', all = T)
      }
      # 整形パート
    }
  }
  assign('totalOpeTable',
         rbind(totalOpeTable,
               c('合計', apply(totalOpeTable[,-1], 2, function(x)sum(x,na.rm = T)))), envir = .GlobalEnv)
  startDate <-
    substring(colnames(totalOpeTable)[2], regexpr(pattern = ':', colnames(totalOpeTable)[2]) + 1)
  lastDate <-
    substring(colnames(totalOpeTable)[ncol(totalOpeTable)],
              regexpr(pattern = ':', colnames(totalOpeTable)[ncol(totalOpeTable)]) + 1)
  sumTotalOpeTable <-
    data.frame(totalOpeTable[,1],
                    apply(totalOpeTable[,-1], 1, function(x) sum(x, na.rm = T)), check.names = F, stringsAsFactors = F)
  colnames(sumTotalOpeTable) <- c('種類', paste0('落札額合計(億円):',startDate,'~',lastDate))
  assign('sumTotalOpeTable',
         rbind(sumTotalOpeTable,c('合計',sum(sumTotalOpeTable[,2]))), envir = .GlobalEnv)
  bufDF <- sumTotalOpeTable[grep('国債買入',sumTotalOpeTable[,1]),]
  assign('sumTotalJGB',
         rbind(bufDF,c('合計',sum(bufDF[,2]))), envir = .GlobalEnv)
  bufDF <- sumTotalOpeTable[grep('指数連動型',sumTotalOpeTable[,1]),]
  assign('sumTotalETF',
         rbind(bufDF,c('合計',sum(bufDF[,2]))), envir = .GlobalEnv)
}
