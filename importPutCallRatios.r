csvFile <-
  c('totalpc.csv','indexpc.csv','equitypc.csv','etppc.csv','vixpc.csv')
csvTitle <-
  c('CBOE Total Exchange Volume and Put/Call Ratios',
    'CBOE Index Volume and Put/Call Ratios',
    'CBOE Equity Volume and Put/Call Ratios',
    'CBOE Exchange Traded Product (ETPs) Volume and Put/Call Ratios',
    'CBOE Volatility Index® (VIX®) Volume and Put/Call Ratios')
putCallRatio <- list()
for(iii in seq(length(csvFile))){
  buf0 <-
    read.csv(file = paste0('http://www.cboe.com/publish/scheduledtask/mktdata/datahouse/',csvFile[iii]),
             header = F,
             quote = "\"",na.strings = c(''),check.names = F,stringsAsFactors = F)
  buf1 <- buf0
  objRow <-
    grep('date',buf1[,1],ignore.case = T)
  if(iii != 5){
    objColumn <-
      grep('product',buf1[objRow-1,],ignore.case = T)
    colnames(buf1) <-
      paste0(gsub('\\s','',buf1[objRow-1,objColumn]),':',buf1[objRow,])
  }else{
    colnames(buf1) <- buf1[objRow,]
  }
  buf2 <- buf1[-c(1:objRow),]
  Date <- as.Date(gsub('([0-9]+)/([0-9]+)/([0-9]+)','\\3-\\1-\\2',buf2[,1]))
  buf3 <-
    data.frame(Date,apply(buf2[,-1],2,as.numeric),stringsAsFactors = F,check.names = F,row.names = NULL)
  putCallRatio[[iii]] <- buf3
  print(tail(buf3,3))
}
