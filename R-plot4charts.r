fun_plot4charts <-
  function(obj = obj,tailN = c(10^10,100,50,30),
           oma = c(0,0,3,0),mar = c(4,4,2,1),type = 'o',dateFormat = '%Y-%m-%d',
           cex.main = 1.2,cex.axis = 1.2){
    par(mfrow = c(2,2),family = 'Meiryo',font.main = 1,oma = oma,mar = mar)
    for(iii in 1:4){
      tmpDF <- fun_fit(obj = tail(obj,tailN[iii]))[,c(1,2,3)]
      dateRange <- paste0(format(range(tmpDF[,1]),dateFormat),collapse = '~')
      plot(x = tmpDF[,1],y = tmpDF[,2],
           type = type,pch = 20,xaxt = 'n',
           xlab = '',ylab = '',
           main = paste0(dateRange,'. n = ',nrow(tmpDF)),
           panel.first = grid(nx = NULL,ny = NULL,lty = 2,equilogs = T))
      axis.Date(side = 1,at = tmpDF[,1],format = dateFormat,padj = 1,cex.axis = 1)
      lines(x = tmpDF[,1],y = tmpDF[,3],type = 'l',col = 'red',lwd = 2)
    }
    mtext(text = paste0(colnames(tmpDF)[2],'\nSource:',dataSource),side = 3,outer = T)
    # dev.off()
  }
