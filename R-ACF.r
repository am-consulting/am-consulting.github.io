fun_acf <-
  function(obj, lag.max = 12*3, objColumn = 2){
    row.names(obj) <- NULL
    lag.max <- lag.max
    par(mar = c(5,5,4,2), family = 'Meiryo', font.main = 1, cex.main = 1.1)
    resultACF <-
      acf(x = obj[,objColumn],
          lag.max = lag.max,
          main = paste0('自己相関係数\n',colnames(obj)[objColumn]),
          panel.first = grid(nx = NULL,
                             ny = NULL,
                             lty = 2,
                             equilogs = T),
          drop.lag.0 = F,
          plot = T)
    assign(x = 'acfDF',
           value = data.frame(Lag = resultACF$lag, ACF = resultACF$acf, stringsAsFactors = F),
           envir = .GlobalEnv)
  }
