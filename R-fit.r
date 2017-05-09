fun_fit <- function(obj, dateColumn = 1, objColumn = 2, needSA = 0){
  library(lubridate)
  obj <-
    na.omit(obj[,c(dateColumn,objColumn)])
  if(needSA!=0){
  SAData <-
    stl(ts(obj[,2], start = c(year(obj[1,1]), month(obj[1,1])), frequency = 12),
        s.window = "periodic")
  SeasonalAdjustment <- as.numeric(obj[,2] - SAData$time.series[,1])
  # SeasonalAdjustment <- SA$time.series[,2] + SA$time.series[,3]
  }
  loessResult <- loess(formula = obj[,2] ~ as.numeric(obj[,1]), degree = 2)
  lmResult <- lm(formula = obj[,2] ~ as.numeric(obj[,1]))
  if(needSA!=0){
  objDF <-
    data.frame(obj,
               `fit-loess` = predict(loessResult),
               `fit-lm` = predict(lmResult),
               SeasonalAdjustment, check.names = F, stringsAsFactors = F)
  }else{
  objDF <-
    data.frame(obj,
               `fit-loess` = predict(loessResult),
               `fit-lm` = predict(lmResult), check.names = F, stringsAsFactors = F)
  }
  # assign('fittedDF', objDF, envir = .GlobalEnv)
  return(objDF)
}
