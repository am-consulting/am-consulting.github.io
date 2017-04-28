fun_arfima <-
  function(obj, objColumn = 2, h = 12, displayRange = 12*2, ciLevel = c(0.95,0.7)){
    if(exists('forecastResultDF',envir = .GlobalEnv)){remove('forecastResultDF',envir = .GlobalEnv)}
    library(forecast)
    result_arfima <-
      arfima(
        y = obj[,objColumn],
        drange = c(0,1),
        estim = 'mle',
        lambda = NULL)
    forecastResult <-
      forecast(result_arfima, level = ciLevel, h = h, plot = F)
    xlim <-
      c(length(forecastResult$x) - displayRange + 1, length(forecastResult$x) + h)
    ylim <-
      c(min(forecastResult$lower,tail(forecastResult$x,displayRange+1)),
        max(forecastResult$upper,tail(forecastResult$x,displayRange+1)))
    xAxisTex <-
      format(x = seq(from = tail(obj,displayRange)[1,1],
                     by = '+1 month',
                     length.out = length(seq(xlim[1],xlim[2]))),
             '%Y-%m')
    par(family = 'Meiryo', mar = c(5,5,5.5,2))
    plot(forecastResult,
         xaxt = 'n',
         font.axis = 1,
         font.main = 1,
         font.lab = 1,
         font.sub = 1,
         cex.main = 1.1,
         xlim = xlim,
         ylim = ylim,
         type = 'o',
         pch = 20)
    panel.first = grid(nx = NULL, ny = NULL, lty = 2, equilogs = T)
    axis(side = 1,
         at = seq(xlim[1],xlim[2]),
         labels = xAxisTex,
         cex.axis = 1.0,
         las = 2)
    text(x = seq(xlim[1],xlim[2]-h),
         y = tail(forecastResult$x,displayRange),
         labels = tail(forecastResult$x,displayRange),
         srt = 90,
         pos = 3,
         offset = 2,
         cex = 0.8)
    mtext(text = paste0(colnames(obj)[objColumn],'\nC.I:', paste0(ciLevel, collapse = ',')),
          side = 3,
          outer = F,
          line = 0)
    # mtext(text = colnames(obj)[objColumn],
    #       side = 2,
    #       outer = F,
    #       line = 3)
    # assign('forecastResultDF',
    #        data.frame(forecastResult,row.names = NULL,stringsAsFactors = F,check.names = F),
    #        envir = .GlobalEnv)
    return(data.frame(forecastResult,row.names = NULL,stringsAsFactors = F,check.names = F))
  }

