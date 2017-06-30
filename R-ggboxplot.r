# https://github.com/kassambara/ggpubr/blob/master/README.md
# https://www.r-bloggers.com/ggplot2-themes-examples/
library(ggpubr)
library(ggsci)
fun_ggboxplot <-
  function(obj,objCol = 2,ggtheme = theme_bw(),palette = "UChicago",add = "jitter",discreteN = 6){
    plotData <- obj[,c(1,objCol)]
    plotData$Year <-
      as.factor(lubridate::year(plotData[,1]))
    colnames(plotData)[2] <- 'Value'
    plotData <-
      subset(plotData,as.character(tail(unique(plotData$Year),discreteN)[1]) <= as.character(plotData$Year))
    p <-
      ggboxplot(plotData,x = "Year",y = 'Value',color = "Year",palette = palette,
                add = add,shape = "Year",ggtheme = ggtheme,repel = T)
    p <- p + ggtitle(colnames(obj)[objCol])+ theme(plot.title = element_text(hjust = 0.5))
    print(p)
    returnDF <-
      ts(data = plotData$Value,start = c(year(plotData[1,1]),month(plotData[1,1])),frequency = 12)
    return(returnDF)
}
