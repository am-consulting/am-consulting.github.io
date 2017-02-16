fun_getStockPriceFromYJ <-
  function(Symbol){
    library(quantmod)
    tmp <- getSymbols.yahooj(Symbols = Symbol,auto.assign = F,return.class = 'data.frame')
    buf <- colnames(tmp)
    buf <- gsub('open','始値',buf,ignore.case = T)
    buf <- gsub('high','高値',buf,ignore.case = T)
    buf <- gsub('low','安値',buf,ignore.case = T)
    buf <- gsub('close','終値',buf,ignore.case = T)
    buf <- gsub('volume','出来高',buf,ignore.case = T)
    buf <- gsub('yj','',buf,ignore.case = T)
    colnames(tmp) <- buf
    tmp0 <-
      data.frame(Date = as.Date(row.names(tmp)),tmp[,1:5],stringsAsFactors = F,check.names = F,row.names = NULL)
    assign(as.character(Symbol),tmp0,envir = .GlobalEnv)
  }
