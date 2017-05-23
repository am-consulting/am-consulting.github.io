fun_meanS <-
  function(objDF,dateCol = 1,objCol = 2,roundN = 2,baseN = 10,powerN = 3,dateFormat = '%Y-%m'){
    windowsFonts(Meiryo = windowsFont("Meiryo"))
    par(mfrow = c(1,1),oma = c(0,0,2,0),family = 'Meiryo')
    obj <-
      na.omit(objDF[,c(dateCol,objCol)])
    x <- obj[,2]
    dateRage <-
      paste0(format(range(obj[,1]),dateFormat),collapse = '~')
    resultDF <- data.frame()
# 最頻値
    breaks <-
      seq(floor(min(x)/baseN^powerN)*baseN^powerN,
          ceiling(max(x)/baseN^powerN)*baseN^powerN,
          baseN^powerN)
    par(mar=c(4,5,0,2))
    tmpHist <-
      hist(x = x,breaks = breaks,col = '#4682b4',xlab = '',main = '',plot = T)
    Mode <-
      paste0(tmpHist$mids[max(tmpHist$counts)==tmpHist$counts],collapse = ',')
# 平均値
    trim <- 0.1
    Mean <-
      round(mean(x = x,na.rm = T),roundN)
    rowN <- 1
    resultDF[rowN,1] <- '平均値'
    resultDF[rowN,2] <- Mean
    resultDF[rowN,3] <- '-'
    MeanTrim <-
      round(mean(x = x,trim = trim,na.rm = T),roundN)
    rowN <- 2
    resultDF[rowN,1] <- 'トリムド平均値'
    resultDF[rowN,2] <- MeanTrim
    resultDF[rowN,3] <- paste0('Trim=',trim)
    WinsorizedMean <-
      round(psych::winsor.mean(x = x,trim = trim,na.rm = T),roundN)
    rowN <- 3
    resultDF[rowN,1] <- 'ウィンザライズド平均値'
    resultDF[rowN,2] <- WinsorizedMean
    resultDF[rowN,3] <- paste0('Trim=',trim)
# ミッドレンジ
    Midrange <-
      round((max(x)+min(x))/2,roundN)
    rowN <- 4
    resultDF[rowN,1] <- 'ミッドレンジ'
    resultDF[rowN,2] <- Midrange
    resultDF[rowN,3] <- '-'
# 中央値
    Median <-
      round(median(x),roundN)
    rowN <- 5
    resultDF[rowN,1] <- '中央値'
    resultDF[rowN,2] <- Median
    resultDF[rowN,3] <- '-'
    colnames(resultDF) <- c('統計量','値','特記')
    resultDF <-
      resultDF[order(resultDF[,2],decreasing = T),]
    # par(mar=c(4,11,0,2))
    # obj0 <-
    #   barplot(resultDF[,2],names.arg = resultDF[,1],
    #           horiz = T,las = 1,plot = T,col = '#4682b4')
    # text(y = obj0,x = resultDF[,2],labels = resultDF[,2],cex = 1,pos = 2,offset = 1,col = 'white')
    mtext(text = paste0(colnames(obj)[2],'. ',dateRage,paste0('. Trim=',trim),'. 最頻値:',Mode),
          side = 3,outer = T,font = 2)
    return(resultDF)
  }
