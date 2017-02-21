library(quantmod)
obj <-
  c('Economic Policy Uncertainty Index for United States','USEPUINDXM',
    'Economic Policy Uncertainty Index for Europe','EUEPUINDXM',
    'Economic Policy Uncertainty Index for China','CHIEPUINDXM',
    'Economic Policy Uncertainty Index for United Kingdom','UKEPUINDXM',
    'Economic Policy Uncertainty Index for Russia','RUSEPUINDXM',
    'Economic Policy Uncertainty Index for Germany','DEEPUINDXM',
    'Economic Policy Uncertainty Index for Japan','JPNEPUINDXM',
    'Economic Policy Uncertainty Index for India','INDEPUINDXM',
    'Economic Policy Uncertainty Index for Italy','ITEPUINDXM',
    'Economic Policy Uncertainty Index for Canada','CANEPUINDXM',
    'Economic Policy Uncertainty Index for France','FREUINDXM',
    'Economic Policy Uncertainty Index for Spain','SPEPUINDXM',
    'Economic Policy Uncertainty Index for Korea','KOREAEPUINDXM'
    )
for(iii in seq(2,length(obj),by = 2)){
  tmp0 <-
    getSymbols(Symbols = obj[iii],
               src = 'FRED',
               auto.assign = F,
               return.class = 'data.frame')
  buf0 <-
    data.frame(Date = as.Date(row.names(tmp0)),tmp0,stringsAsFactors = F,row.names = NULL)
  colnames(buf0)[2] <-
    obj[iii - 1]
  if(iii == 2){
    EPUallData <- buf0
  }else{
    EPUallData <- merge(EPUallData,buf0,by='Date',all=T)
  }
}
