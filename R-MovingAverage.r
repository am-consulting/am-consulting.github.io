fun_MovingAverage <-
  function(obj, objColumn = 2, n = 12, dateFormat = '%Y-%m', plot = 0){
    buf0 <-
      obj[,c(1,objColumn)]
    objMA <-
      data.frame(buf0,
                 SMA = TTR::SMA(buf0[,2], n = n),
                 EMA = TTR::EMA(buf0[,2], n = n),
                 stringsAsFactors = F,
                 check.names = F,
                 row.names = NULL)
    colnames(objMA)[3:4] <-
      paste0(colnames(objMA)[2], ':', colnames(objMA)[3:4], ':n=',n)
    assign('MovingAverageDF', objMA)
    return(objMA)
    if(plot == 1){
      par(family = 'Meiryo',font.main = 1,mar = c(4,5,2,2))
      lineColor <- c('black','red','blue')
      plot(x = MovingAverageDF[,1],
           y = MovingAverageDF[,2],
           type = 'o',
           pch = 20,
           cex = 0.9,
           xlab = '',
           ylab = colnames(MovingAverageDF)[2],
           xaxt = 'n',
           col = lineColor[1],
           lwd = 1,
           main = paste0('オリジナル & ',monthS,'ヶ月移動平均'),
           panel.first = grid(nx = NULL,
                              ny = NULL,
                              lty = 2,
                              equilogs = T))
      axis.Date(side = 1,
                at = MovingAverageDF[,1],
                format = dateFormat,
                padj = 1,
                cex.axis = 1)
      lines(x = MovingAverageDF[,1],y = MovingAverageDF[,3],col = lineColor[2],lwd = 2)
      lines(x = MovingAverageDF[,1],y = MovingAverageDF[,4],col = lineColor[3],lwd = 2)
      graphics::legend(
        x = 'topleft',
        col = lineColor,
        lty = 1,
        legend = colnames(MovingAverageDF)[c(2,3,4)],
        cex = 1,
        bty = 'n',
        lwd = c(1,2,2))
      abline(h = 0,col = 'red')
    }
}
