fun_gglboxpotPM <- function(obj,personCol = 3,objCol = 2,ggtheme = theme_bw(),
         palette = "UChicago",add = "jitter",discreteN = 6,dataSource = dataSource){
  plotData <- obj[,c(personCol,objCol)]
  colnames(plotData)[1] <- 'Person'
  colnames(plotData)[2] <- 'Value'
  plotData <-
    plotData[which(plotData[,1] == tail(unique(plotData[,1]),discreteN)[1])[1]:nrow(plotData),]
  p <-
    ggboxplot(plotData,x = "Person",y = 'Value',color = "Person",palette = palette,
              add = add,shape = "Person",ggtheme = ggtheme,repel = T)
  p <- p + xlab('') + ylab('') + theme(legend.position = "none")
  p <- p + ggtitle(paste0(colnames(obj)[objCol],'\nSource:',dataSource))
  p <- p + theme(plot.title =   element_text(hjust = 0.5,family = 'Meiryo',face = 'plain'))
  p <- p + theme(legend.text =  element_text(hjust = 0.5,family = 'Meiryo',face = 'plain'))
  p <- p + theme(axis.title.x = element_text(hjust = 0.5,family = 'Meiryo',face = 'plain'))
  p <- p + theme(axis.title.y = element_text(hjust = 0.5,family = 'Meiryo',face = 'plain'))
  p <- p + theme(axis.text =    element_text(hjust = 0.5,family = 'Meiryo',face = 'plain'))
  print(p)
}
