csvURL <-c('http://www.sca.isr.umich.edu/files/tbmics.csv',
           'http://www.sca.isr.umich.edu/files/tbmiccice.csv',
           'http://www.sca.isr.umich.edu/files/tbmpx1px5.csv')
for(iii in seq(length(csvURL))){
  tmp0 <-
    read.csv(file = csvURL[iii],stringsAsFactors = F,check.names = F,as.is = T)
  columnY <-
    grep('yyyy',colnames(tmp0),ignore.case = T)
  columnM <-
    grep('month',colnames(tmp0),ignore.case = T)
  Date <-
    paste0(tmp0[,columnY],'-',
           match(substring(tmp0[,columnM],1,3),month.abb),'-1')
  Date <-
    as.Date(Date)
  tmp <-
    data.frame(Date, tmp0[,-c(columnY,columnM),drop=F],stringsAsFactors = F)
  colnames(tmp) <-
    gsub('icc','CurrentIndex',colnames(tmp),ignore.case = T)
  colnames(tmp) <-
    gsub('ice','ExpectedIndex',colnames(tmp),ignore.case = T)
  colnames(tmp) <-
    gsub('ICS_ALL','IndexOfConsumerSentiment',colnames(tmp),ignore.case = T)
  colnames(tmp) <-
    gsub('PX_MD','NextYear',colnames(tmp),ignore.case = T)
  colnames(tmp) <-
    gsub('PX5_MD','Next5Years',colnames(tmp),ignore.case = T)
  if(iii == 1){
    IndexOfConsumerSentiment <- tmp
  }else if(iii == 2){
    ComponentsOfTheIndexOfConsumerSentiment <- tmp
  }else{
    ExpectedChangesInInflationRates <- tmp
  }
}
