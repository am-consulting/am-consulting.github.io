fun_makeDiffTable <-
  function(obj, lag = 1, diff = 1, roundDigits = 10){
    diffDF <-
      data.frame(tail(obj[,1],- lag * diff),
                 round(diff(as.matrix(obj[,-1]), lag = lag, differences = diff), roundDigits),
                 check.names = F,
                 stringsAsFactors = F)
    colnames(diffDF) <- colnames(obj)
    assign('diffDF', diffDF, envir = .GlobalEnv)
  }

fun_makeDiffRatioTable <-
  function(obj, lag = 1, diff = 1, roundDigits = 1){
    diffRatioDF <-
      data.frame(tail(obj[,1],- lag * diff),
                 round(diff(as.matrix(obj[,-1]), lag = lag, differences = diff)/head(obj[,-1], - lag * diff) * 100, roundDigits),
                 check.names = F,
                 stringsAsFactors = F)
    colnames(diffRatioDF) <- colnames(obj)
    assign('diffRatioDF', diffRatioDF, envir = .GlobalEnv)
  }
