# https://stackoverflow.com/questions/30768521/converting-time-series-to-data-frame-matrix-or-table
# https://stackoverflow.com/questions/5331901/transforming-a-time-series-into-a-data-frame-and-back
library(lubridate)
fun_convertToTS <-
  function(tsData = obj,dateCol = 1,dataCol = 2,monthabb = 1){
    if(4 < length(unique(month(tsData[,dateCol])))){
      if(3 < length(unique(day(tsData[,dateCol])))){
        frequencyN <- 365
      }else{
        frequencyN <- 12
      }
    }else{
      if(1 == length(unique(month(tsData[,dateCol])))){
        frequencyN <- 1
      }else{
        frequencyN <- 4
      }
    }
    returnTS <-
      ts(data = tsData[,dataCol],
         start = c(year(tsData[1,dateCol]),month(tsData[1,dateCol])),
         frequency = frequencyN)
    returnDF <-
      data.frame(tapply(returnTS,
                        list(year = floor(time(returnTS)), month = cycle(returnTS)), c),
                 check.names = F,stringsAsFactors = F)
    if(monthabb == 1){
      colnames(returnDF) <-
        month.abb[as.numeric(colnames(returnDF))]
    }
    returnList <-
          list('returnTS' = returnTS,
               'returnDF' = returnDF)
    return(returnList)
  }
