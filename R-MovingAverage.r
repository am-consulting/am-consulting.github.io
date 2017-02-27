fun_MovingAverage <-
  function(obj, objColumn = 2, n = 12){
    buf0 <-
      obj[,c(1,objColumn)]
    objMA <-
      data.frame(buf0,
                 SMA = TTR::SMA(buf0[,2], n = n),
                 EMA = TTR::EMA(buf0[,2], n = n),
                 stringsAsFactors = F,
                 check.names = F,
                 row.names = NULL)
    colnames(objMA)[3:4] <-
      paste0(colnames(objMA)[2], ':', colnames(objMA)[3:4])
    assign('MovingAverageDF', objMA, envir = .GlobalEnv)
}
