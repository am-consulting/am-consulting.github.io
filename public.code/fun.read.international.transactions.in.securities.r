fun.read.international.transactions.in.securities.r <- function(load.library=F){
  if(load.library==T){lapply(c('Nippon'),require,character.only = T)}
  url <-
    'http://www.mof.go.jp/international_policy/reference/itn_transactions_in_securities/week.csv'
  buf <-
    read.csv(file = url,header = F,skip = 0,stringsAsFactor = F,na.strings = c(''),
             check.names = F,fileEncoding = 'cp932')
  for(rrr in 1:nrow(buf)){
    tmp <- buf[rrr,]
    tmp <- grep("Acquisition",tmp)
    if(length(tmp)!= 0){break}
  }
  tmp <- na.omit(buf[-(1:rrr),])
  tmp.data.set <-
    data.frame(sapply(tmp[,1],zen2han),
               apply(tmp[,-1],2,function(x){as.numeric(gsub(",","",x))}),
               check.names = F,stringsAsFactors = F,row.names = NULL)
  for(obj.row in c(8,11)){
    tmp <- NA
    for(ccc in 1:ncol(buf)){
      if(!is.na(buf[obj.row,ccc])){tmp <- gsub('^[0-9]\\.|\\s','',zen2han(buf[obj.row,ccc]))}
      buf[obj.row,ccc] <- tmp
    }
  }
  colnames(tmp.data.set) <- paste0(buf[8,],':',buf[11,],':',buf[13,])
  colnames(tmp.data.set)[1] <- '期間'
  obj <-
    data.frame(`週初`=as.Date(gsub('\\.','-',gsub('(.+)~.+','\\1',tmp.data.set[,1]))),
               tmp.data.set,
               check.names = F,stringsAsFactors = F,row.names = NULL)
  sheet.title <- gsub('・','･',gsub('\\s','',zen2han(buf[1,1])))
  sheet.unit <- zen2han(buf[4,20])
  return.list <-
    list('international.transactions.in.securities' = obj,
         'sheet.title' = sheet.title,
         'sheet.unit' = sheet.unit)
  return(return.list)
}
