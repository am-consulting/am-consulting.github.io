fun_dw <-
  function(dwDF = obj, objX = 2, objY = 3){
    library(lmtest)
    cat(paste0('x:',colnames(dwDF)[objX],' , y:',colnames(dwDF)[objY]))
    x <- dwDF[,objX]
    y <- dwDF[,objY]
    print(dwtest(y~x))
    par(family = 'Meiryo', font.main = 1, font.lab = 1,
        mar = c(5,5,3,1), cex.main = 1.1, cex.lab = 1.0, mfrow = c(1,2))
    plot(x = x,
         y = y,
         type = 'p',
         pch = 20,
         xlab = colnames(dwDF)[objX],
         ylab = colnames(dwDF)[objY],
         panel.first = grid(nx = NULL,
                            ny = NULL,
                            lty = 2,
                            equilogs = T))
    resultLM <-
      lm(y~x)
    print(summary(resultLM))
    abline(resultLM, col = 'red')
    residualDF <-
      data.frame(dwDF[,1,drop = F],
                 Residual = resultLM$residuals,
                 stringsAsFactors = F,
                 check.names = F)
    plot(x = residualDF[,1],
         y = residualDF[,2],
         xlab = colnames(residualDF)[1],
         ylab = colnames(residualDF)[2],
         type = 'p',
         pch = 20,
         panel.first = grid(nx = NULL,
                            ny = NULL,
                            lty = 2,
                            equilogs = T))
  }
