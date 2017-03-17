library(quantmod);library(lubridate)
windowsFonts(Meiryo = windowsFont("Meiryo"))
# buf <-
#   na.omit(getSymbols(Symbols = 'DEXJPUS',src = 'FRED',auto.assign = F))
# buf <-
#   data.frame(Date = index(buf),buf,stringsAsFactors = F,check.names = F,row.names = NULL)
fun_monthlyTSbyYear <- function(obj0,mainTitle = ''){
for(mm in 1:12){
  obj <- subset(obj0,month(obj0[,1]) == mm)
  yyyy <-
    unique(year(obj[,1]))
  cntP <- cntN <- 0
  ylimL <-
    10^10
  ylimU <-
    -10^10
  xlimU <- 0
  scaleData <- list()
  for(iii in 1:length(yyyy)){
    tsData <-
      subset(obj,year(obj[,1])==yyyy[iii])
    scaleData[[iii]] <-
      scale(x = tsData[,2],center = tsData[1,2])
    ylimL <- min(ylimL,scaleData[[iii]])
    ylimU <- max(ylimU,scaleData[[iii]])
    xlimU <- max(xlimU,nrow(scaleData[[iii]]))
  }
  for(iii in 1:length(yyyy)){
    ifelse(0 <= tail(scaleData[[iii]],1),cntP <- cntP + 1,cntN <- cntN + 1)
    if(iii == 1){
      par(family = 'Meiryo',font.main = 1)
      plot(scaleData[[iii]],
           type = 'o',
           ylim = c(floor(ylimL),ceiling(ylimU)),
           xlim = c(1,xlimU),
           pch = 20,
           xlab = '',
           ylab = 'Normalized data',
           main = paste0(mainTitle,
                         '. ',
                         paste0(range(yyyy),collapse = ' ~ '),
                         '. Month:',
                         month.abb[mm]),
           panel.first = grid(nx = NULL,
                              ny = NULL,
                              lty = 2,
                              equilogs = T))
      }else if(iii!=length(yyyy)){
        lines(scaleData[[iii]],
              type = 'o',
              pch = 20)
        }else{
          lines(scaleData[[iii]],
                type = 'o',
                pch = 20,
                col = 'blue',
                lwd = 2)
        }
  }
  abline(h = 0, lwd = 2, col = 'red')
  mtext(text = paste0('Positive:',cntP,',Negative:',cntN),side = 3,cex = 1)
}
}
