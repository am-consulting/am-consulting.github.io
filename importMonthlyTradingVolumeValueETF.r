library(gdata)
options(download.file.method='libcurl')

perl <- gdata:::findPerl('perl')
dataURL <-
  c('http://www.jpx.co.jp/markets/statistics-equities/misc/tvdivq00000023wp-att/historical-toushin.xls')
Sys.sleep(1) #avoid to overload
buf0 <-
  read.xls(dataURL[1],
           perl = perl,
           check.names = F,
           header = F,
           stringsAsFactors = F,
           sheet = 1,
           fileEncoding = 'utf-8',
           na.strings = c(''))
buf0[4,] <- gsub('([^(\n)]+)\n.+','\\1',buf0[4,])
buf0[5,] <- gsub('([^(\n)]+)\n.+','\\1',buf0[5,])
buf0[6,] <- gsub('([^(\n)]+)\n.+','\\1',buf0[6,])
tmp <- NA
for(ccc in seq(ncol(buf0))){
  if(!is.na(buf0[4,ccc])){tmp <- buf0[4,ccc]}
  buf0[4,ccc] <- tmp
}
colnames(buf0) <-
  paste0(buf0[4,],':',buf0[5,],':',buf0[6,])
buf1 <-
  buf0[-c(1:6),]
Date <-
  as.Date(gsub('([0-9]+)/([0-9]+)','\\1-\\2-1',buf1[,1]))
buf2 <-
  data.frame(Date,apply(buf1[,-1],2,function(x)as.numeric(gsub(',','',x))),
             stringsAsFactors = F,row.names = NULL,check.names = F)
buf3 <-
  buf2[,apply(buf2,2,function(x)sum(is.na(x)))!=nrow(buf2)]
colnames(buf3) <-
  gsub('立会.+','立会日数',colnames(buf3))
assign(paste0('monthlyTradingVolumeValueETF'), buf3, envir = .GlobalEnv)
