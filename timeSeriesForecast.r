# library(quantmod)
# tmp <- getSymbols('USD/JPY', src = "oanda", auto.assign = F, from = Sys.Date()-365*5, to = Sys.Date())
# buf0 <- tmp
# dataSet <- data.frame(Date = as.Date(index(buf0)),buf0,check.names = F,stringsAsFactors = F,row.names = NULL)
library(nonlinearTseries);library(forecast);library(tseries)
fun_timeSeriesForecast <-
  function(obj = dataSet,
           surrogateSignificance = 0.05, surrogateK = 1, surrogateOnesided = F, surrogatePlot = F,
           arimaIC = 'aic',
           arfimaEstim = 'mle',
           acfLag = 12, acfType = 'correlation', acfMainTitle = ''){
    result_acfTest <<-
      acf(
        x = obj,
        lag.max = acfLag,
        type = acfType,
        drop.lag.0 = F,
        plot = T,
        main = acfMainTitle
        )
    panel.first = grid(nx = NULL,
                       ny = NULL,
                       lty = 2,
                       equilogs = T)
    result_adfTest <<-
      adf.test(
        x = obj
        )
    result_surrogateTest <<-
      surrogateTest(
        time.series = obj,
        significance = surrogateSignificance,
        K = surrogateK,
        one.sided = surrogateOnesided,
        FUN = timeAsymmetry,
        do.plot = surrogatePlot
        )
    if(surrogatePlot == T){
      panel.first = grid(nx = NULL,
                         ny = NULL,
                         lty = 2,
                         equilogs = T)
      }
    result_nnetar <<-
      nnetar(
        y = obj
        )
    result_arima <<-
      auto.arima(
        y = obj,
        ic = arimaIC,
        trace = F,
        stepwise = F,
        approximation = F
        )
    result_arfima <<-
      arfima(
        y = obj,
        drange = c(0,1),
        estim = arfimaEstim,
        lambda = NULL
        )
    }
