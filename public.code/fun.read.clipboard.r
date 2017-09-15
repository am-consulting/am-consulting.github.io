fun.read.clipboard <- function(na.strings = c('na','')){
  clipboard <-
    read.table('clipboard',header = F,sep = '\t',stringsAsFactor = F,na.strings = na.strings,check.names = F)
  return(clipboard)
}
