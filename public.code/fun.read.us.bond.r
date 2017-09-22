fun.read.us.bond <- function(load.library = F){
  if(load.library==T){lapply(c('quantmod','rvest'),require,character.only = T)}
  us.bond <-
    c('10-Year Treasury Constant Maturity Rate (DGS10)',
      '10-Year Treasury Constant Maturity Minus 2-Year Treasury Constant Maturity (T10Y2Y)',
      '10-Year Breakeven Inflation Rate (T10YIE)',
      '5-Year, 5-Year Forward Inflation Expectation Rate (T5YIFR)')
  for(iii in seq(length(us.bond))){
    return.list <- fun.read.from.fred(index = us.bond[iii])
    tmp <- return.list$data.set.xts
    tmp.df <-
      data.frame(Date = index(tmp),tmp,stringsAsFactors = F,check.names = F,row.names = NULL)
    colnames(tmp.df)[2] <- paste0(return.list$index.title,'(',return.list$index.unit,')')
    if(iii == 1){us.bond.data <- tmp.df}else{us.bond.data <- merge(us.bond.data,tmp.df,by='Date',all=T)}
  }
  return.list <-
    list('us.bond.data' = us.bond.data,
         'lab.title' = '米国財務省証券',
         'data.source' = 'FRED')
  return(return.list)
}
