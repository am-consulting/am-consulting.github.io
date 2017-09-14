fun.read.ilbs.icbs <- function(load.library = F,path.to.folder = '/Desktop/R_Data_Write/',sheet = 2){
  # The Results of BIS International Locational Banking Statistics and International Consolidated Banking Statistics in Japan
  # https://www.boj.or.jp/statistics/bis/ibs/index.htm/
  if(load.library==T){lapply(c('XLConnect','Nippon','lubridate'),require,character.only = T)}
  buf.wd <- getwd()
  path.to.folder <- paste0('C:/Users/',Sys.info()['user'],path.to.folder)
  setwd(path.to.folder)
  target.url <- 'https://www.boj.or.jp/statistics/bis/ibs/hbis11.xlsx'
  xls.file <- gsub('.+/([^/]+)','\\1',target.url)
  download.file(url = target.url,xls.file,mode = 'wb')
  sheet.name <- getSheets(loadWorkbook(xls.file))
  buf0 <- readWorksheetFromFile(xls.file,sheet = sheet,check.names = F,header = F)
  sheet.title <- zen2han(buf0[1,1]);sheet.unit <- gsub('百万','兆',zen2han(buf0[2,1]))
  region.col.s <- which(!is.na(buf0[3,]))
  region.col.e <- c(region.col.s[-1]-1,ncol(buf0))
  cnt <- 0
  bis.data <- list()
  for(iii in seq(length(region.col.s))){
    buf1 <- buf0[,c(1,2,region.col.s[iii]:region.col.e[iii])]
    tmp <- NA;for(ccc in seq(ncol(buf1))){if(!is.na(buf1[3,ccc])){tmp <- buf1[3,ccc]};buf1[3,ccc] <- tmp}
    tmp <- NA;for(ccc in seq(ncol(buf1))){if(!is.na(buf1[4,ccc])){tmp <- buf1[4,ccc]};buf1[4,ccc] <- tmp}
    currency.col.s <- which(!is.na(buf1[5,]))
    currency.col.e <- c(currency.col.s[-1]-1,ncol(buf1))
    for(iiii in seq(length(currency.col.s))){
      buf2 <- buf1[,c(1,2,currency.col.s[iiii]:currency.col.e[iiii])]
      tmp <- NA;for(ccc in seq(ncol(buf2))){if(!is.na(buf2[5,ccc])){tmp <- buf2[5,ccc]};buf2[5,ccc] <- tmp}
      tmp <- NA;for(ccc in seq(ncol(buf2))){if(!is.na(buf2[6,ccc])){tmp <- buf2[6,ccc]};buf2[6,ccc] <- tmp}
      col.name <- sapply(paste0(buf2[3,],':',buf2[4,],':',buf2[5,],':',buf2[6,],':',buf2[7,]),zen2han)
      colnames(buf2) <- gsub('\\d+\\.|\\(\\d+\\)|:?NA','',col.name)
      buf3 <- buf2[which(!is.na(as.numeric(substring(buf2[,1],1,4))))[1]:nrow(buf2),]
      tmp <- NA;for(rrr in seq(nrow(buf3))){if(!is.na(buf3[rrr,1])){tmp <- buf3[rrr,1]};buf3[rrr,1] <- tmp}
      buf3[,1] <-
        as.Date(paste0(substring(buf3[,1],1,4),'-',gsub('月末','',buf3[,2]),'-1')) %m+% months(1) -1
      buf4 <- buf3[,-2]
      colnames(buf4)[1] <- 'Date'
      cnt <- cnt + 1
      bis.data[[cnt]] <-
        data.frame(buf4[,1,drop=F],apply(buf4[,-1],2,function(x)as.numeric(gsub(',','',x))*10^-6),
                   stringsAsFactors = F,check.names = F,row.names = NULL)
    }
  }
  setwd(buf.wd)
  returnList <-
    list('bis.data' = bis.data,
         'sheet.title' = sheet.title,
         'sheet.unit' = sheet.unit)
  return(returnList)
}
