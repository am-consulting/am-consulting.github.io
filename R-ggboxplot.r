# https://github.com/kassambara/ggpubr/blob/master/README.md
# https://www.r-bloggers.com/ggplot2-themes-examples/
library(ggpubr)
library(ggsci)
fun_ggboxplot <-
  function(obj,dateCol = 1,objCol = 2,ggtheme = theme_bw(),palette = "UChicago",add = "jitter",discreteN = 6,
           dataSource = dataSource){
    plotData <- obj[,c(dateCol,objCol)]
    plotData$Year <-
      as.factor(lubridate::year(plotData[,1]))
    colnames(plotData)[2] <- 'Value'
    plotData <-
      subset(plotData,as.character(tail(unique(plotData$Year),discreteN)[1]) <= as.character(plotData$Year))
    p <-
      ggboxplot(plotData,x = "Year",y = 'Value',color = "Year",palette = palette,
                add = add,shape = "Year",ggtheme = ggtheme,repel = T)
    p <- p + xlab('') + ylab('') + theme(legend.position = "none")
    p <- p + ggtitle(paste0(colnames(obj)[objCol],'\nSource:',dataSource))
    p <- p + theme(plot.title =   element_text(hjust = 0.5,family = 'Meiryo',face = 'plain',size = 16))
    p <- p + theme(legend.text =  element_text(hjust = 0.5,family = 'Meiryo',face = 'plain'))
    p <- p + theme(axis.title.x = element_text(hjust = 0.5,family = 'Meiryo',face = 'plain'))
    p <- p + theme(axis.title.y = element_text(hjust = 0.5,family = 'Meiryo',face = 'plain'))
    p <- p + theme(axis.text =    element_text(hjust = 0.5,family = 'Meiryo',face = 'plain',size = 16))
    print(p)
    returnDF <-
      ts(data = plotData$Value,start = c(year(plotData[1,1]),month(plotData[1,1])),frequency = 12)
    return(returnDF)
}
