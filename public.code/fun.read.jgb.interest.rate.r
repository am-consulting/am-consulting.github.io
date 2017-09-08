fun.read.jgb.interest.rate <- function(){
  base.url <- 'http://www.mof.go.jp/english/jgbs/reference/interest_rate/'
  csv.file <- c('historical/jgbcme_all.csv','jgbcme.csv')
  data.set <- list()
  for(iii in seq(length(csv.file))){
    Sys.sleep(1) # To prevent server overload
    data.set[[iii]] <-
      read.csv(file = paste0(base.url,csv.file[iii]),header = T,skip = 1,stringsAsFactor = F,
               check.names = F,na.strings = '-')
  }
  if(colnames(data.set[[1]]) == colnames(data.set[[2]])){
    tmp <- rbind(data.set[[1]],data.set[[2]])
    tmp[,1] <- as.Date(tmp[,1])
    jgb.interest.rate <-
      data.frame(Date = tmp[,1],apply(tmp[,-1,drop = F],2,as.numeric),stringsAsFactors = F,
                 check.names = F,row.names = NULL)
    return(jgb.interest.rate)
  }else{
    stop('There is a difference in the column names of Current Data and Historical Data.')
  }
}
