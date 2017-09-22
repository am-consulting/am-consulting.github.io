fun.read.daily.index <- function(load.library = F){
  if(load.library==T){lapply(c('Nippon'),require,character.only = T)}
  obj <-
    read.csv(file = 'http://www.cboe.com/publish/scheduledtask/mktdata/datahouse/vixcurrent.csv',
             header = T,as.is = T,check.names = F,stringsAsFactors = F,skip = 1)
  obj[,1] <-
    as.Date(gsub('([0-9]+)/([0-9]+)/([0-9]+)','\\3-\\1-\\2',obj[,1]))
  vix.close <-
    obj[,grep('date|close',colnames(obj),ignore.case = T)]
  #-------------------------------------------
  obj <-
    read.csv(file = 'http://indexes.nikkei.co.jp/nkave/historical/nikkei_stock_average_daily_en.csv',
      header = T,as.is = T,check.names = F,stringsAsFactors = F)
  obj <- na.omit(obj[,c(1,2)])
  colnames(obj) <- c('Date',paste0('NIKKEI225:',colnames(obj)[2]))
  obj[,1] <- as.Date(obj[,1])
  nikkei225.close <- obj
  #-------------------------------------------
  target.url <-
    'https://www.mizuhobank.co.jp/rate/market/csv/quote.csv'
  buf <-
    read.csv(file = target.url,header = F,
             quote = "\"",na.strings = c('','*****'),check.names = F,stringsAsFactors = F,skip = 1)
  colnames(buf) <-
    sapply(paste0(buf[1,],':',buf[2,]),zen2han)
  buf <- buf[-c(1:2),]
  historical.fx.data <-
    data.frame(Date=as.Date(buf[,1]),apply(buf[,-1],2,as.numeric),
               stringsAsFactors = F,check.names = F,row.names = NULL)
  colnames(historical.fx.data)[-1] <- colnames(buf)[-1]
  #-------------------------------------------
  tmp0 <-
    read.csv(file = 'http://www.cboe.com/publish/scheduledtask/mktdata/datahouse/skewdailyprices.csv',
             header = T,as.is = T,check.names = F,stringsAsFactors = F,skip = 1)
  tmp1 <- tmp0[,colnames(tmp0) != '']
  tmp1[,1] <-
    as.Date(gsub('([0-9]+)/([0-9]+)/([0-9]+)','\\3-\\1-\\2',tmp1[,1]))
  skew.cboe <- na.omit(tmp1)
  #-------------------------------------------
  returnList <-
    list('vix.close' = vix.close,
         'nikkei225.close' = nikkei225.close,
         'historical.fx.data' = historical.fx.data,
         'skew.cboe' = skew.cboe)
  return(returnList)
}
