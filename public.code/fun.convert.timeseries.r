fun.convert.timeseries <- function(obj,index.name = 'Index'){
  if(class(data.set)[1] == 'xts'){
    data.set.xts <- obj
    data.set.df <-
      data.frame(Date = index(data.set.xts),data.set.xts,check.names = F,row.names = NULL,stringsAsFactors = F)
    data.set.ts <-
      ts(data = data.set.xts,start = c(year(head(index(data.set.xts),1)),month(head(index(data.set.xts),1))),frequency = 12)
  }
  if(class(data.set)[1] == 'data.frame'){
    data.set.df <- obj
    data.set.xts <- as.xts(data.set.df[,-1],order.by = as.Date(data.set.df[,1]))
    colnames(data.set.xts) <- colnames(data.set.df)[2]
    data.set.ts <-
      ts(data = data.set.xts,start = c(year(head(index(data.set.xts),1)),month(head(index(data.set.xts),1))),frequency = 12)
  }
  if(class(data.set)[1] == 'ts'){
    data.set.ts <- obj
    data.set.df <- data.frame(as.Date(time(data.set.ts)),as.numeric(data.set.ts),stringsAsFactors = F,row.names = NULL)
    colnames(data.set.df) <- c('Date',index.name)
    data.set.xts <- as.xts(data.set.df[,-1],order.by = as.Date(data.set.df[,1]))
    colnames(data.set.xts) <- colnames(data.set.df)[2]
  }
  returnList <-
    list('data.set.df' = data.set.df,
         'data.set.ts' = data.set.ts,
         'data.set.xts' = data.set.xts)
  return(returnList)
}
