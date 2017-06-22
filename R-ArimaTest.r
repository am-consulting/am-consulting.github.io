fun_ArimaTest <-
  function(obj,tailN = c(10^10,12*10,12*5,12*3),dateColumn = 1,valueColumn = 2,
           h = 12,ic = 'aic',level = c(0.6,0.8,0.95)){
    forecastByArima <- list()
    accuracyList <- list()
    Date <-
      format(tail(seq(tail(obj[,1],1),by = 'month',length.out = 13),-1),'%Y-%m')
    par(mar=c(5,4,4,1),family='Meiryo',oma=c(3,0,0,0),mfrow=c(2,2))
    for(iii in seq(length(tailN))){
      tsData <-
        tail(obj,tailN[iii])
      row.names(tsData) <-
        NULL
      TimeSeriesData <-
        head(tsData[,valueColumn],-h)
      resultArima <-
        auto.arima(y = TimeSeriesData,ic = ic,trace = F,stepwise = T)
      resultForecast <-
        forecast(object = resultArima,level = level,h = h)
      plot(resultForecast)
      mtext(text = paste0('Tail=',tailN[iii],'months'),side = 1,outer = F,padj = 2.6,font = 3)
      lines(tsData[,2])
      buf0 <-
        accuracy(resultForecast,tail(tsData[,2],h))
      accuracyList[[iii]] <-
        buf0
      buf1 <-
        data.frame(Set = paste0(row.names(buf0),':',tailN[iii],'months'),buf0,
                   stringsAsFactors = F,check.names = F,row.names = NULL)
      if(iii==1){accuracyResult <- buf1}else{accuracyResult <- rbind(accuracyResult,buf1)}
    }
    mtext(text = paste0(colnames(tsData)[valueColumn],'\nLevel:',paste0(level,collapse = ', '),
                        '\nNumber of periods for forecasting=',h),
          side = 1,outer = T,padj = 0.5,font = 4)
    accTraining <-
      accuracyResult[grep('training',accuracyResult$Set,ignore.case = T),]
    accTest <-
      accuracyResult[-grep('training',accuracyResult$Set,ignore.case = T),]
    ################################################################################
    par(mar=c(5,4,4,1),family='Meiryo',oma=c(3,0,0,0),mfrow=c(2,2))
    for(iii in seq(length(tailN))){
      tsData <-
        tail(obj,tailN[iii])
      TimeSeriesData <-
        tsData[,valueColumn]
      resultArima <-
        auto.arima(y = TimeSeriesData,ic = ic,trace = F,stepwise = T)
      resultForecast <-
        forecast(object = resultArima,level = level,h = h)
      plot(resultForecast)
      mtext(text = paste0('Tail=',tailN[iii],'months'),side = 1,outer = F,padj = 2.6,font = 3)
      buf0 <- summary(resultForecast)
      buf0$Date <- Date
      forecastByArima[[iii]] <- buf0
    }
    mtext(text = paste0(colnames(tsData)[valueColumn],'\nLevel:',paste0(level,collapse = ', '),
                        '\nNumber of periods for forecasting=',h),
          side = 1,outer = T,padj = 0.5,font = 4)
    returnList <-
      list('forecastByArima' = forecastByArima,
           'accuracyList' = accuracyList,
  	       'accTraining' = accTraining,
           'accTest' = accTest)
    return(returnList)
  }
