fun_doSimulation <-
  function(x,breaksBy = 0.01,finalbreaksBy = 2,startValue = 114,
           simulationLength = 100,simulationNumber = 100){
    par(mfrow = c(1,2), family = 'Meiryo', font.main = 1, cex.main = 1.1, oma = c(0,0,0,0))
    breaks <-
      seq(from = floor(min(x)), to = ceiling(max(x)) + breaksBy, by = breaksBy)
    resultHist <-
      hist(x = x,breaks =breaks,plot = F)
    buf0 <-
      data.frame(resultHist$mids,
                 resultHist$counts,
                 resultHist$counts/sum(resultHist$counts))
    histTable <-
      buf0[buf0[,2]!=0,]
    checkSum <<- sum(histTable[,3])
    fun_simulate <-
      function(){
        simulationResult <- vector()
        simulationResult[1] <- startValue
        for(iii in 2:simulationLength){
          prob <-
            sample(x = histTable[,1],
                   size = 1,
                   replace = T,
                   prob = histTable[,3])
          simulationResult[iii] <-
            simulationResult[iii - 1]*(1 + prob/100)
        }
        assign('simulationResult', simulationResult, envir = .GlobalEnv)
      }
      simulationResultS <- data.frame()
      for(iii in 1:simulationNumber){
        fun_simulate()
        if(iii == 1){
          simulationResultS <- simulationResult
        }else{
          simulationResultS <- data.frame(simulationResultS,
                                          simulationResult,
                                          stringsAsFactors = F)
        }
      }
      colnames(simulationResultS) <-
        paste0('sim',seq(1,simulationNumber))
      ylim <-
        c(min(simulationResultS),max(simulationResultS))
      plot(x = simulationResultS[,1],
           type = 'o',
           pch = 20,
           ylim = ylim,
           xlab = '',
           ylab = '',
           panel.first = grid(nx = NULL,
                              ny = NULL,
                              lty = 2,
                              equilogs = T),
           main = paste0('Initial:',startValue))
      for(iii in 2:simulationNumber){
        lines(simulationResultS[,iii],
              type = 'o',
              pch = 20)
      }

      abline(h = startValue, col = 'red', lwd = 2)
      x0 <-
        unlist(tail(simulationResultS,1))
      breaks <-
        seq(from = floor(min(x0)), to = ceiling(max(x0)) + finalbreaksBy, by = finalbreaksBy)
      finalHist <-
        hist(x = x0, breaks = breaks,xlab = '',main = '',col='gray',plot = T)
      panel.first = grid(nx = NULL,
                         ny = NULL,
                         lty = 2,
                         equilogs = T)
      assign('simulationResultS',
             simulationResultS,
             envir = .GlobalEnv)
      assign('finalHist',
             finalHist,
             envir = .GlobalEnv)
      finalHistDF <-
        data.frame(finalHist$mids,
                   finalHist$counts,
                   finalHist$counts/sum(finalHist$counts)*100)
      colnames(finalHistDF) <-
        c('Mid','Count','Ratio(%)')
      assign('finalHistDF',
             finalHistDF,
             envir = .GlobalEnv)
  }
