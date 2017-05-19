fun_CCF <-
  function(objDF,y1 = 2,y2 = 3,lagmax = 30,plotLog = 'T',dateFormat = '%Y-%m'){
    windowsFonts(Meiryo = windowsFont("Meiryo"))
    fun_plotCCF <-
      function(){
        par(mar = c(5,5,6,1),family = 'Meiryo')
        ccfResult <-
          ccf(x = obj01,y = obj02,
              lag.max = lagmax,na.action = na.omit,
              plot = plotLog,panel.first = grid(nx = NULL,ny = NULL,lty = 2,equilogs = T),
              main = paste0(paste0(colnames(obj)[c(y1,y2)],collapse = '×'),'\n',dateRange,'\n',mainTxt))
        return(ccfResult)
      }
    obj <- na.omit(objDF)
    dateRange <-
      paste0(format(range(obj[,1]),dateFormat),collapse = '~')
    obj01 <- obj[,y1]
    obj02 <- obj[,y2]
    mainTxt <- 'Level'
    resultLevel <- fun_plotCCF()
    objDiff <- fun_makeDiffTable(obj = obj,lag = 1,diff = 1)
    obj01 <- objDiff[,y1]
    obj02 <- objDiff[,y2]
    mainTxt <- '1st Difference'
    result1stDiff <- fun_plotCCF()
    obj01 <- rank(x = obj[,y1],ties.method = 'average')
    obj02 <- rank(x = obj[,y2],ties.method = 'average')
    mainTxt <- 'Spearman\'s rank correlation coefficient'
    resultSpearman <- fun_plotCCF()
    returnList <-
      list('resultLevel' = resultLevel,
           'result1stDiff' = result1stDiff,
  	       'resultSpearman' = resultSpearman)
    return(returnList)
  }
