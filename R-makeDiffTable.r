fun_makeDiffTable <-
  function(obj, lag = 1, diff = 1){
    diffDF <-
      data.frame(tail(obj[,1],-1),
                 diff(as.matrix(obj[,-1]), lag = lag, differences = diff),
                 check.names = F,
                 stringsAsFactors = F)
    colnames(diffDF) <- colnames(obj)
    assign('diffDF', diffDF, envir = .GlobalEnv)
  }
