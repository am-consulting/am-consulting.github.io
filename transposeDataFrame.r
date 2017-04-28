fun_transposeDataFrame <- function(obj, tailN = 5, dateFormat = '%Y-%m-%d', colName = 'Item'){
  if(exists('tDF',envir = .GlobalEnv)){remove('tDF',envir = .GlobalEnv)}
  if(dateFormat!=0){obj[,1] <- format(obj[,1], dateFormat)}
  buf <- t(tail(obj, tailN))
  buf <- data.frame(row.names(buf), buf, check.names = F, stringsAsFactors = F, row.names = NULL)
  colnames(buf) <- buf[1,]
  buf <- buf[-1,]
  colnames(buf)[1] <- colName
  buf[,-1] <- apply(buf[,-1,drop=F], 2, as.numeric)
  assign('tDF',buf,envir = .GlobalEnv)
  # return(buf)
}
# http://stackoverflow.com/questions/4837477/remove-objects-in-globalenv-from-within-a-function
