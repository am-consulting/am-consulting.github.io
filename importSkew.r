tmp0 <-
  read.csv(file = 'http://www.cboe.com/publish/scheduledtask/mktdata/datahouse/skewdailyprices.csv',
           header = T,
           as.is = T,
           check.names = F,
           stringsAsFactors = F,
           skip = 1)
tmp1 <-
  tmp0[,colnames(tmp0) != ""]
tmp1[,1] <-
  as.Date(gsub('([0-9]+)/([0-9]+)/([0-9]+)','\\3-\\1-\\2',tmp1[,1]))
assign('skewCBOE',tmp1,envir = .GlobalEnv)
