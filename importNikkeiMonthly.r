urlToFile <-
  'http://indexes.nikkei.co.jp/nkave/historical/nikkei_stock_average_monthly_jp.csv'
tmp0 <-
  read.csv(urlToFile,
           header = T,
           skip = 0,
           stringsAsFactor = F,
           na.strings = c("", "***"),
           check.names = F,
           fileEncoding = "cp932")
tmp1 <-
  na.omit(tmp0)
tmp1[,1] <-
  as.Date(tmp1[,1])
colnames(tmp1)[-1] <-
  paste0('日経平均株価:',colnames(tmp1)[-1])
colnames(tmp1)[1] <-
  'Date'
assign('nikkeiMonthly', tmp1, envir = .GlobalEnv)
