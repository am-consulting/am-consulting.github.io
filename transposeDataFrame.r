fun_transposeDataFrame <- function(obj, tailN = 5, dateFormat = '%Y-%m-%d', colName = 'Item'){
  obj[,1] <- format(obj[,1], dateFormat)
  buf <- t(tail(obj, tailN))
  buf <- data.frame(row.names(buf), buf, check.names = F, stringsAsFactors = F, row.names = NULL)
  colnames(buf) <- buf[1,]
  buf <- buf[-1,]
  colnames(buf)[1] <- colName
  buf[,-1] <- apply(buf[,-1,drop=F], 2, as.numeric)
  tDF <- buf
  return(tDF)
}
