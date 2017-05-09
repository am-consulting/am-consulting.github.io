fun_historicalVolatility <-
  function(obj, objColumn = 2, width = 30){
    HV <- vector()
    for(rrr in width:nrow(obj)){
      tmp <-
        obj[c((rrr-width+1):rrr),c(1,objColumn)]
      diffRatioDF <-
        fun_makeDiffRatioTable(obj = tmp,lag = 1,roundDigits = 3)
      HV[rrr] <- sd(diffRatioDF[,2]/100) * sqrt(260) * 100
    }
    # assign('historicalVolatility',
    #        data.frame(Date = tail(obj[,1],-(width-1)),
    #                   `HistoricalVolatility(%)` = na.omit(HV),
    #                   stringsAsFactors = F,
    #                   check.names = F),
    #        envir = .GlobalEnv)
    historicalVolatility <-
      data.frame(Date = tail(obj[,1],-(width-1)),
                 `HistoricalVolatility(%)` = na.omit(HV),
                 stringsAsFactors = F,
                 check.names = F)
    return(historicalVolatility)
  }
