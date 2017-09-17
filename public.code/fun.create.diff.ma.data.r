fun.create.diff.ma.data <- function(load.library = F,obj,col.date = 1,col.target = 2,lag = 1,diff = 1,round.dig = 5,n = 12,historical.width = 30,time.ratio.daily = 260){
  if(load.library==T){lapply(c('TTR','lubridate'),require,character.only = T)}
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
  # historical volatility part
  if(4 < length(unique(month(obj[,1])))){
    if(1 < length(unique(day(obj[,1])))){time.ratio <- time.ratio.daily}else{time.ratio <- 12}
  }
  historical.volatility <- vector()
  for(rrr in historical.width:nrow(diff.df)){
    tmp <- diff.df[c((rrr-historical.width+1):rrr),grep('\\(比',colnames(diff.df))]
    historical.volatility[rrr] <- sd(tmp/100)*sqrt(time.ratio)*100
  }
  historical.volatility.df <-
    data.frame(diff.df[,1,drop=F],historical.volatility,
               stringsAsFactors = F,check.names = F)
  colnames(historical.volatility.df)[2] <- paste0('Historical Volatility(width:',historical.width,')')
  # historical volatility part
  diff.ma.data <- merge(merge(moving.ave,diff.df,all=T),historical.volatility.df,all=T)
  return(diff.ma.data)
}
