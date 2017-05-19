library(quantmod)
tmp <-
  getSymbols('EXJPUS', src = 'FRED', auto.assign = F)
USDJPYmonthly <-
  data.frame(Date=index(tmp),tmp,stringsAsFactors = F,check.names = F,row.names = NULL)
colnames(USDJPYmonthly)[2] <- 'USD/JPY'
