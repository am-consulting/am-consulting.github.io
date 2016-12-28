fun_fit <- function(obj, dateColumn = 1, objColumn = 2){
  SAData <-
    stl(ts(obj[,objColumn], start = c(year(obj[1,dateColumn]), month(obj[1,dateColumn])), frequency = 12),
        s.window = "periodic")
  SeasonalAdjustment <- as.numeric(obj[,objColumn] - SAData$time.series[,1])
  # SeasonalAdjustment <- SA$time.series[,2] + SA$time.series[,3]
  loessResult <- loess(formula = obj[,objColumn] ~ as.numeric(obj[,dateColumn]), degree = 2)
  lmResult <- lm(formula = obj[,objColumn] ~ as.numeric(obj[,dateColumn]))
  objDF <-
    data.frame(obj[,c(dateColumn, objColumn)],
               `fit-loess` = predict(loessResult),
               `fit-lm` = predict(lmResult),
               SeasonalAdjustment, check.names = F, stringsAsFactors = F)
  assign('fittedDF', objDF, envir = .GlobalEnv)
}
