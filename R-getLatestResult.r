fun_latestResult <-
  function(obj, objColumn = 2, orderDirection = 0, orderColumn = 1, dateColumn = 1, dateFormat = '%Y-%m'){
    if(orderDirection == 1){
    obj <-
      obj[order(obj[,orderColumn], decreasing = T),]
    }
    assign('latestResult',
           paste0(ifelse(dateFormat == 0,
                         tail(obj[,dateColumn],1),
                         format(tail(obj[,dateColumn],1),dateFormat)),
                  ':',
                  paste0(paste0(colnames(obj)[objColumn],
                  ':',
                  format(round(tail(obj[,objColumn],1),10),big.mark = ',')),collapse = ' , ' )),
           envir = .GlobalEnv)
}
