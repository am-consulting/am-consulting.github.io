library(AnomalyDetection)
fun_Anomaly <-
  function(obj,dateCol = 1,valueCol = 2,max_anoms = 0.10,direction = 'both',plot = T,
           alpha = 0.5,y_log = F,title = '',tz = 'GMT'){
    tsWithTZ <-
      obj[,c(dateCol,valueCol)]
    tsWithTZ[,1] <-
      as.POSIXct(x = tsWithTZ[,1],tz = tz)
    detectResult <-
      AnomalyDetectionTs(x = tsWithTZ, max_anoms = max_anoms, direction = direction,
                         plot = plot, alpha = alpha, y_log = y_log, title = title)
    returnList <-
      list('tsWithTZ' = tsWithTZ,
           'detectResult' = detectResult)
    return(returnList)
  }
