fun.read.japan.cpi <- function(){
  # required package:Nippon
  cpi.id <- c('全国','000031431696',
              '全国:前月比','000031431701',
              '全国:前年同月比','000031431706',
              '東京都区部','000031431786',
              '東京都区部:前月比','000031431791',
              '東京都区部:前年同月比','000031431796')
  base.url <- 'http://www.e-stat.go.jp/SG1/estat/Csvdl.do?sinfid='
  cpi.japan <- list()
  cnt <- 0
  for(iii in seq(1,length(cpi.id),by = 2)){
    Sys.sleep(1) # To prevent server overload
    buf <-
      read.csv(file = paste0(base.url,cpi.id[iii+1]),header = F,skip = 0,
               stringsAsFactor = F,check.names = F,na.strings = c(""),fileEncoding = 'cp932')
    row.name <- grep('品目$',buf[,1])
    row.weight <- grep('万分比',buf[,1])
    colnames(buf) <- sapply(paste0(buf[row.name,],':',buf[row.weight,]),zen2han)
    buf1 <- buf[!is.na(as.numeric(buf[,1])),]
    buf1[,1] <- as.Date(paste0(substring(buf1[,1],1,4),'-',substring(buf1[,1],5,6),'-1'))
    buf1[,-1] <- apply(buf1[,-1],2,as.numeric)
    colnames(buf1) <- paste0(cpi.id[iii],':',colnames(buf1))
    cnt <- cnt + 1
    cpi.japan[[cnt]] <-
      data.frame(Date = buf1[,1],buf1[,-1],
                 stringsAsFactors = F,check.names = F,row.names = NULL)
  }
  return(cpi.japan)
}
