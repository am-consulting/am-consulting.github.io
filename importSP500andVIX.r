library(quantmod)
tmp <-
  getSymbols(Symbols = '^GSPC',auto.assign = F)
colnames(tmp) <-
  gsub('gspc','S&P500',colnames(tmp),ignore.case = T)
SP500xts <- tmp
SP500 <-
  data.frame(Date = index(tmp),tmp,stringsAsFactors = F,row.names = NULL,check.names = F)

tmp <-
  getSymbols(Symbols = '^VIX',auto.assign = F)
VIXxts <- tmp
VIX <-
  data.frame(Date = index(tmp),tmp,stringsAsFactors = F,row.names = NULL,check.names = F)
