fun.create.diff.ma.data <- function(obj,col.date = 1,col.target = 2,lag = 1,diff = 1,round.dig = 5,n = 12){
  # required package:TTR
  obj <- obj[,c(col.date,col.target)]
  moving.ave <-
    data.frame(obj,SMA = SMA(obj[,2], n = n),EMA = EMA(obj[,2], n = n),
               stringsAsFactors = F,check.names = F,row.names = NULL)
  colnames(moving.ave)[3:4] <- paste0(colnames(moving.ave)[3:4],':n=',n)
  orig <- tail(obj,-lag*diff)
  diff.diff <-
    round(diff(obj[,2],lag = lag,differences = diff),round.dig)
  diff.ratio <-
    round(diff(obj[,2],lag = lag,differences = diff)/head(obj[,-1],-lag*diff)*100,round.dig)
  diff.df <-
    data.frame(orig,diff.diff,diff.ratio,stringsAsFactors = F,row.names = NULL)
  colnames(diff.df) <-
    gsub('diff.diff',paste0(colnames(obj)[2],'(差,',lag,',',diff,')'),colnames(diff.df))
  colnames(diff.df) <-
    gsub('diff.ratio',paste0(colnames(obj)[2],'(比,',lag,',',diff,')'),colnames(diff.df))
  diff.ma.data <- merge(moving.ave,diff.df,all=T)
  return(diff.ma.data)
}
