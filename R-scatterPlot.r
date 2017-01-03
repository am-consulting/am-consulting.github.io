fun_scatterPlot <-
  function(obj, mar = c(5,5,6,2), objDate = 1, objX = 2, objY = 3, dateFormat = '%Y-%m',
           dataSource = '', asp = 0, needLim = 0, cexText = 1, srtText = 90, posText = 1, offsetText = 1,
           cexAxis =1, cexLab = 1, cexMain = 1, cexLegend = 1, cexPlot = 1, pch = 20, plotType = 'o'){
    par(mar = mar, family = 'Meiryo')
    windowsFonts(Meiryo = windowsFont("Meiryo"))
    minValue <- min(obj[,objX:objY])
    maxValue <- max(obj[,objX:objY])
    plot(obj[,objX],
         obj[,objY],
         asp = if(asp == 1){asp},
         col = 'blue',
         cex = cexPlot,
         pch = pch,
         type = plotType,
         main =
           paste0(paste0(colnames(obj)[objX:objY],collapse = '\n × \n'),
                  '\n',
                  '対象期間:', paste0(format(range(obj[,objDate]), dateFormat), collapse = '~'),
                  '\nSource:', dataSource),
         cex.axis = 1, cex.lab = 1, cex.main = 1, cex.sub = 1,
         xlab = colnames(obj)[objX],
         ylab = colnames(obj)[objY],
         xlim = if(needLim == 1){c(minValue, maxValue)},
         ylim = if(needLim == 1){c(minValue, maxValue)})
    panel.first = grid(nx = NULL,
                       ny = NULL,
                       lty = 2,
                       equilogs = T)
    graphics::text(obj[,objX],
                   obj[,objY],
                   labels = format(obj[,objDate], dateFormat),
                   pos = posText,
                   srt = srtText,
                   cex = cexText,
                   offset = offsetText)
    lines(par()$usr[1:2],
          par()$usr[1:2],
          col = 'red')
  }
