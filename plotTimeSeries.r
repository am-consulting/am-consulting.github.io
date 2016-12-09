fun_plotTimeSeries <-
  function(obj,
           objX = 1,
           objYL = 2,
           objYR = 3,
           typeL = 'l',
           typeR = 'l',
           dateFormat = '%Y-%m-%d',
           chartType = 2,
           lineColor = c('blue', 'lightcoral', 'black'),
           lwdL = 1,
           lwdR = 2) {
    if(chartType != 0){
      mainTitle <- paste0(dataTitle,
                          '\n',
                          colnames(obj)[objYL],
                          ' × ',
                          colnames(obj)[objYR])
      maxValue <- max(obj[,objYL],
                      obj[,objYR])
      minValue <- min(obj[,objYL],
                      obj[,objYR])
    }else{ # 1系列のみの場合
      mainTitle <- colnames(obj)[objYL]
    }
    par(mar = c(3,5,4,5),
        family = 'Meiryo')
    plot(x = obj[,objX],
         y = obj[,objYL],
         type = typeL,
         col = lineColor[1],
         xlab = '',
         ylab = '',
         xaxt = 'n',
         ylim = if(chartType == 1){c(minValue, maxValue)},
         main = paste(mainTitle,
                      '\nSource:',
                      dataSource),
         cex.axis = 1,
         cex.lab = 1,
         cex.main = 1,
         lwd = lwdL)
    lo <- loess(formula = obj[,objYL] ~ as.numeric(obj[,objX]),
                degree = 2)
    lines(x = obj[,objX],
          y = predict(lo),
          col = lineColor[1],
          lwd = 1,
          lty = 2)
    panel.first = grid(nx = NULL,
                       ny = NULL,
                       lty = 2,
                       equilogs = T)
    if(chartType != 0){ # 2系列の場合
      if(chartType == 1){
        lines(x = obj[,objX],
              y = obj[,objYR],
              col = lineColor[2],
              lwd = 1,
              type = typeR)
      }else{
        par(new=T)
        plot(x = obj[, objX],
             y = obj[, objYR],
             type = typeR,
             col = lineColor[2],
             xlab = '',
             ylab = '',
             xaxt = 'n',
             yaxt = 'n',
             cex.axis = 1,
             cex.lab = 1,
             cex.main = 1,
             lwd = lwdR)
        panel.first = grid(nx = NULL,
                           ny = NULL,
                           lty = 2,
                           equilogs = T)
        axis(side = 4,
             cex.axis = 1,
             cex.lab = 1)
        mtext(text = colnames(obj)[objYR],
              side = 4,
              line = 3.2,
              cex = 1)
      }
      lo <- loess(formula = obj[, objYR] ~ as.numeric(obj[,objX]),
                  degree = 2)
      lines(x = obj[,objX],
            y = predict(lo),
            col = lineColor[2],
            lwd = 1,
            lty = 2)
      graphics::legend(
        x = 'topleft',
        col = lineColor,
        lty = 1,
        legend = colnames(obj)[c(objYL,objYR)],
        cex = 1,
        bty = 'n',
        lwd = 2)
    }
    axis.Date(side = 1,
              at = obj[,objX],
              format = dateFormat,
              padj = 1,
              cex.axis = 1.0)
    mtext(text = colnames(obj)[objYL],
          side = 2,
          line = 3.2,
          cex = 1)
  }
