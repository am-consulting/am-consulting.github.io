# library(quantmod)
# tmp <- getSymbols('USD/JPY', src = "oanda", auto.assign = F, from = Sys.Date()-365*5, to = Sys.Date())
# buf0 <- tmp
# dataSet <- data.frame(Date = as.Date(index(buf0)),buf0,check.names = F,stringsAsFactors = F,row.names = NULL)

fun_timeSeriesDataFundamentalStatistics <-
  function(obj = dataSet, objCCC = 2, lagN = 1, diffN = 1){
    library(tseries);library(lubridate)
    dataSet <- dataSet0 <- na.omit(obj)
    # 日付フォーマット確認 Part
    dateFormat <- '%Y-%m-%d'
    dateUnit <- 'Day'
    if(length(unique(month(dataSet[,1]))) == 1){
      dateFormat <- '%Y'
      dateUnit <- 'Year'
    }else if(length(unique(day(dataSet[,1]))) == 1){
      dateFormat <- '%Y-%m'
      dateUnit <- 'Month'
    }
    # 日付フォーマット確認 Part

    colnames(dataSet0)[objCCC] <-
      paste0(colnames(dataSet0)[objCCC],'<br>n=',nrow(dataSet0),':',
             paste0(format(range(dataSet0[,1]),dateFormat),collapse = '~'))

    dataSet1 <- data.frame(Date = tail(dataSet[,1], -(lagN * diffN)),
                           diff(as.matrix(dataSet[,-1]),lag = lagN,differences = diffN),
                           check.names = F,stringsAsFactors = F)
    colnames(dataSet1)[objCCC] <-
      paste0(colnames(dataSet)[objCCC],'<br>n=',nrow(dataSet1),':lag=',lagN,':diff=',diffN,':',
             paste0(format(range(dataSet1[,1]),dateFormat),collapse = '~'))

    # unit root test
    resultADF <- adf.test(dataSet0[,objCCC])
    resultADF <- rbind(cbind(resultADF$statistic),
                       cbind(resultADF$parameter),
                       cbind(resultADF$alternative),
                       cbind(resultADF$p.value),
                       cbind(resultADF$method),
                       cbind(paste0(format(range(dataSet0[,1]),dateFormat), collapse = '~')))
    row.names(resultADF)[3:6] <- c('Alternative','p.value','Method','Period')
    colnames(resultADF)[1] <- 'Result'

    resultADFdiff <- adf.test(diff(dataSet0[,objCCC], lag = lagN, differences = diffN))
    resultADFdiff <- rbind(cbind(resultADFdiff$statistic),
                       cbind(resultADFdiff$parameter),
                       cbind(resultADFdiff$alternative),
                       cbind(resultADFdiff$p.value),
                       cbind(resultADFdiff$method),
                       cbind(paste0(format(range(tail(dataSet0[,1], -(lagN * diffN))),dateFormat), collapse = '~')),
                       cbind(paste0('lag:',lagN,',diff:',diffN)))
    row.names(resultADFdiff)[3:7] <- c('Alternative','p.value','Method','Period','Lag')
    colnames(resultADFdiff)[1] <- 'Result'
    # unit root test

    # 原データ 基本統計量 Part
    summaryTable <- cbind(summary(dataSet[,objCCC]))
    latestValue <- tail(dataSet[,objCCC],1)
    latestDate <- format(tail(dataSet[,1],1),dateFormat)
    statisticsTable <-
      data.frame(cbind(
        summaryTable,
        round(latestValue/summaryTable*100,1),
        latestValue-summaryTable))
    colnames(statisticsTable) <-
      c(colnames(dataSet)[objCCC],
        paste0('Latest(',latestDate,':', latestValue,')<br>to Summary(%)'),
        paste0('Latest(',latestDate,':', latestValue,')<br>to Summary(Diff)'))
    colnames(statisticsTable)[1] <-
      paste0(colnames(statisticsTable)[1],'<br>',paste0(format(range(dataSet[,1]),dateFormat),collapse = '~'))
    # 原データ 基本統計量 Part

    # 差分データ 基本統計量 Part
    dataSetDiff <- data.frame(tail(dataSet[,1],-(lagN * diffN)),diff(dataSet[,objCCC],lag = lagN,differences = diffN))
    dataRangeDiff <- paste0(as.character(format(range(dataSetDiff[,1]),dateFormat)),collapse = '~')
    appendTitle <- paste0('<br>lag=',lagN,',diff=',diffN)
    colnames(dataSetDiff) <- c('Date',paste0(colnames(dataSet)[objCCC],appendTitle))
    dataSet01Positive  <-subset(dataSetDiff,0 <= dataSetDiff[,2])
    dataSet01Negative <-subset(dataSetDiff,0 >  dataSetDiff[,2])
    statisticsTableDiff <-
      data.frame(cbind(cbind(summary(dataSet01Positive[,-1])),cbind(summary(dataSet01Negative[,-1]))))
    colnames(statisticsTableDiff) <-
      paste0(colnames(dataSet)[objCCC], paste0(appendTitle,c(':Positive',':Negative')),':',dataRangeDiff)
    # 差分データ 基本統計量 Part

    # 差分データの正負構成比(%)
    RatioPositive <- round(nrow(dataSet01Positive)/nrow(dataSetDiff)*100)
    RatioNegative <- round(nrow(dataSet01Negative)/nrow(dataSetDiff)*100)
    statisticsTableDiffRatio <-
      data.frame(rbind(NumberPositive = nrow(dataSet01Positive),
                       RatioPositive,
                       NumberNegative = nrow(dataSet01Negative),
                       RatioNegative,
                       Total = nrow(dataSetDiff)),check.names = F,stringsAsFactors = F)
    colnames(statisticsTableDiffRatio)[1] <- paste0(colnames(dataSet)[objCCC],appendTitle,':',dataRangeDiff)
    # 差分データの正負構成比(%)

    # 差分データの最大値、最小値
    statisticsTableDiffMaxMin <-
      data.frame(rbind(dataSetDiff[which.max(dataSetDiff[,2]),],dataSetDiff[which.min(dataSetDiff[,2]),]),
                 check.names = F,stringsAsFactors = F)
    colnames(statisticsTableDiffMaxMin)[2] <-
      paste0(colnames(statisticsTableDiffMaxMin)[2],':Max&Min',':',dataRangeDiff)
    statisticsTableDiffMaxMin[,1] <- format(statisticsTableDiffMaxMin[,1],dateFormat)
    # 差分データの最大値、最小値

    # Step1:正負の識別
    for(rrr in 1:nrow(dataSetDiff)){
      if(0 <= dataSetDiff[rrr,objCCC]){
        dataSetDiff[rrr,3] <- 1;dataSetDiff[rrr,4] <- 0
      }else{
        dataSetDiff[rrr,3] <- 0;dataSetDiff[rrr,4] <- 1
      }
    }
    colnames(dataSetDiff)[3:4] <- c('Positive','Negative')
    # Step1:正負の識別

    # Step2:正負それぞれの連続回数を判定
    dataSetDiff0 <- dataSetDiff
    for(rrr in 2:nrow(dataSetDiff0)){
      if(dataSetDiff0[rrr,3]==1){dataSetDiff0[rrr,3] <- dataSetDiff0[rrr-1,3]+dataSetDiff0[rrr,3]}
      if(dataSetDiff0[rrr,4]==1){dataSetDiff0[rrr,4] <- dataSetDiff0[rrr-1,4]+dataSetDiff0[rrr,4]}
    }
    # Step2:正負それぞれの連続回数を判定

    # Step3:正の連続が途切れる列を抽出
    dataSetDiff0Positive <-
      rbind(dataSetDiff0[which(dataSetDiff0[,3]==0)-1,c(1,2,3)],tail(dataSetDiff0[,c(1,2,3)],1))
    dataSetDiff0Positive <- dataSetDiff0Positive[which(dataSetDiff0Positive[,3]!=0),]
    # Step3:正の連続が途切れる列を抽出

    # Step4:負の連続が途切れる列を抽出
    dataSetDiff0Negative <-
      rbind(dataSetDiff0[which(dataSetDiff0[,4]==0)-1,c(1,2,4)],tail(dataSetDiff0[,c(1,2,4)],1))
    dataSetDiff0Negative <- dataSetDiff0Negative[which(dataSetDiff0Negative[,3]!=0),]
    # Step4:負の連続が途切れる列を抽出

    # Step5:正の連続の頻度
    statSequencePositive <- data.frame()
    seqList <- unique(dataSetDiff0Positive[,3])[order(unique(dataSetDiff0Positive[,3]))]
    for(iii in 1:length(seqList)){
      statSequencePositive[iii,1] <- seqList[iii]
      statSequencePositive[iii,2] <- nrow(subset(dataSetDiff0Positive,dataSetDiff0Positive[,3]==seqList[iii]))
    }
    colnames(statSequencePositive) <- c(paste0('x Straight Positive ',dateUnit,'s'),'N')
    statSequencePositive$Ratio <- round(statSequencePositive[,2]/sum(statSequencePositive[,2])*100,1)
    colnames(statSequencePositive)[3] <-
      paste0(colnames(dataSet)[objCCC],appendTitle,':',colnames(statSequencePositive)[3],':',dataRangeDiff)
    # Step5:正の連続の頻度

    # Step6:負の連続の頻度
    statSequenceNegative <- data.frame()
    seqList <- unique(dataSetDiff0Negative[,3])[order(unique(dataSetDiff0Negative[,3]))]
    for(iii in 1:length(seqList)){
      statSequenceNegative[iii,1] <- seqList[iii]
      statSequenceNegative[iii,2] <- nrow(subset(dataSetDiff0Negative,dataSetDiff0Negative[,3]==seqList[iii]))
    }
    colnames(statSequenceNegative) <- c(paste0('x Straight Negative ',dateUnit,'s'),'N')
    statSequenceNegative$Ratio <- round(statSequenceNegative[,2]/sum(statSequenceNegative[,2])*100,1)
    colnames(statSequenceNegative)[3] <-
      paste0(colnames(dataSet)[objCCC],appendTitle,':',colnames(statSequenceNegative)[3],':',dataRangeDiff)
    # Step6:負の連続の頻度

    # global data
    dateFormat <<- dateFormat
    dateUnit <<- dateUnit
    timeSeriesdata <- dataSet0
    timeSeriesdata[,1] <- format(timeSeriesdata[,1],dateFormat)
    timeSeriesdata <<- timeSeriesdata
    timeSeriesdataDiff <<- dataSet1
    timeSeriesdataDiff[,1] <- format(timeSeriesdataDiff[,1],dateFormat)
    timeSeriesdataDiff <<- timeSeriesdataDiff
    statisticsTable <<- statisticsTable
    statisticsTableDiff <<- statisticsTableDiff
    statisticsTableDiffRatio <<- statisticsTableDiffRatio
    statisticsTableDiffMaxMin <<- statisticsTableDiffMaxMin
    statSequencePositive <<- statSequencePositive
    statSequenceNegative <<- statSequenceNegative
    resultADF <<- resultADF
    resultADFdiff <<- resultADFdiff
    # global data
}
