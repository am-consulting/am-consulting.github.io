fun_plotTimeSeries <-
  function(obj,
           objX = 1,
           objYL = 2,
           objYR = 3,
           typeL = 'l',
           typeR = 'l',
           dateFormat = '%Y-%m-%d',
           chartType = 2,
           lineColor = c('blue', 'red', 'lightcoral', 'black'),
           lwdL = 1,
           lwdR = 2,
           dataTitle = '',
           mar = c(3,5,4,5),
           dataSource = '',
           cex.axis = 1, cex.lab = 1, cex.main = 1, cex.sub = 1, cex.legend = 1,
           needLefLab = 1,
           fitLcolor = 1,
           fitRcolor = 2,
           yaxisReverseL = FALSE,
           yaxisReverseR = FALSE,
           font.axis = 1,
           font.main = 1,
           font.lab = 1,
           font.sub = 1) {
    if(chartType != 0){
      obj <- obj[,c(objX,objYL,objYR)]
      mainTitle <- paste0(dataTitle,
                          '\n',
                          colnames(obj)[2],
                          ' × ',
                          colnames(obj)[3])
    }else{ # 1系列のみの場合
      obj <- na.omit(obj[,c(objX,objYL)])
      mainTitle <- paste0(dataTitle,
                          '\n',
                          colnames(obj)[2])
    }
    if(chartType == 1){
      maxValue <- max(na.omit(obj[,2]),
                      na.omit(obj[,3]))
      minValue <- min(na.omit(obj[,2]),
                      na.omit(obj[,3]))
    }
    par(mar = mar,
        family = 'Meiryo',
        font.axis = font.axis,
        font.main = font.main,
        font.lab = font.lab,
        font.sub = font.sub
        )
    plot(x = obj[,1],
         y = obj[,2],
         type = typeL,
         col = lineColor[1],
         xlab = '',
         ylab = '',
         xaxt = 'n',
         ylim =
           if(chartType == 1){
             if(yaxisReverseL == F){
               c(minValue, maxValue)
             }else{
               rev(c(minValue, maxValue))
             }
           }else{
             if(yaxisReverseL == T){
               rev(range(na.omit(obj[,2])))
             }
           },
         main = paste(mainTitle,
                      '\n',
                      paste0(format(range(obj[,1]), dateFormat), collapse = '~'),
                      '\nSource:',
                      dataSource),
         cex.axis = cex.axis,
         cex.lab = cex.lab,
         cex.main = cex.main,
         lwd = lwdL)
    if(fitLcolor != 0){
    lo <- loess(formula = obj[,2] ~ as.numeric(obj[,1]),
                degree = 2)
    lines(x = obj[,1],
          y = predict(lo),
          col = lineColor[fitLcolor],
          lwd = lwdL,
          lty = 2)
    }
    panel.first = grid(nx = NULL,
                       ny = NULL,
                       lty = 2,
                       equilogs = T)
    if(chartType != 0){ # 2系列の場合
      if(chartType == 1){
        lines(x = obj[,1],
              y = obj[,3],
              col = lineColor[2],
              lwd = lwdR,
              type = typeR)
      }else{
        par(new=T)
        plot(x = obj[, 1],
             y = obj[, 3],
             type = typeR,
             col = lineColor[2],
             xlab = '',
             ylab = '',
             xaxt = 'n',
             yaxt = 'n',
             cex.axis = cex.axis,
             cex.lab = cex.lab,
             cex.main = cex.main,
             lwd = lwdR,
             ylim = if(yaxisReverseR == T){rev(range(na.omit(obj[, 3])))})
        panel.first = grid(nx = NULL,
                           ny = NULL,
                           lty = 2,
                           equilogs = T)
        axis(side = 4,
             cex.axis = cex.axis,
             cex.lab = cex.lab)
        mtext(text = colnames(obj)[3],
              side = 4,
              line = 3.2,
              cex = cex.lab)
      }
      if(fitRcolor != 0){
      lo <- loess(formula = obj[,3] ~ as.numeric(obj[,1]),
                  degree = 2)
      lines(x = obj[,1],
            y = predict(lo),
            col = lineColor[fitRcolor],
            lwd = lwdR,
            lty = 2)
      }
      graphics::legend(
        x = 'topleft',
        col = lineColor,
        lty = 1,
        legend = colnames(obj)[c(2,3)],
        cex = cex.legend,
        bty = 'n',
        lwd = 2)
    }
    axis.Date(side = 1,
              at = obj[,1],
              format = dateFormat,
              padj = 1,
              cex.axis = cex.axis)
    if(needLefLab == 1){
    mtext(text = colnames(obj)[2],
          side = 2,
          line = 3.2,
          cex = cex.lab)
    }
  }
