fun_cointegration <-
  function(obj, objX = 2, objY = 3){
    par(mfrow = c(1,2), family = 'Meiryo', mar = c(5,5,3,3))
    resultLM <-
      lm(obj[,objY] ~ obj[,objX])
    plot(x = obj[,objX],
         y = obj[,objY],
         pch = 20,
         xlab = colnames(obj)[objX],
         ylab = colnames(obj)[objY],
         panel.first = grid(nx = NULL,
                            ny = NULL,
                            lty = 2,
                            equilogs = T))
    abline(resultLM,col='red',lwd=2)
    plot(resultLM$residuals,
         type = 'h',
         ylab = 'Residuals',
         panel.first = grid(nx = NULL,
                            ny = NULL,
                            lty = 2,
                            equilogs = T))
    cat(paste0('x:',colnames(obj)[objX],' , y:',colnames(obj)[objY]))
    `x~y` <- obj[,c(objX,objY)]
    tseries::po.test(x = `x~y`)
  }
