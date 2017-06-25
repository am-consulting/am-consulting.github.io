fun_changesInSlope <- function(obj,objCol = 2,h = 12){
  slopeDF <- data.frame()
  for(rrr in h:nrow(obj)){
    tmp <- obj[(rrr-h+1):rrr,c(1,objCol)]
    lmResult <- lm(tmp[,2]~tmp[,1])
    slopeDF[rrr,1] <- obj[rrr,1]
    slopeDF[rrr,2] <- lmResult$coefficients[2]
  }
  slopeDF[,1] <-
    as.Date(slopeDF[,1])
  colnames(slopeDF) <-
    c('Date','Slope')
  slopeDF <- na.omit(slopeDF)
  changesInConditions <-
    merge(obj[,c(1,objCol)],slopeDF,by = 'Date',all = 'T')
  par(mar=c(4,5,4,5),family='Meiryo',font.main=1,cex.main=1)
  plot(changesInConditions[,c(1,2)],type='l',col = '#4169e1',
       xlab='',ylab=colnames(changesInConditions)[2],
       main=paste0(colnames(changesInConditions)[2],'\n',
                   paste0(format(range(changesInConditions[,1]),'%Y-%m'),collapse = '~'),'\nRange(months):',h),
       panel.first = grid(nx = NULL,ny = NULL,lty = 2,equilogs = T))
  par(new=T)
  plot(changesInConditions[,c(1,3)],type='h',col='#696969',
       xlab = '',ylab = '',xaxt = 'n',yaxt = 'n',
       panel.first = grid(nx = NULL,ny = NULL,lty = 2,equilogs = T))
  axis(side = 4,cex.axis = 1)
  mtext(text = colnames(changesInConditions)[3],side = 4,line = 2.2,cex = 1)
  changesInSlope <-
    na.omit(data.frame(head(changesInConditions,-1),
                       Product=head(changesInConditions$Slope,-1)*tail(changesInConditions$Slope,-1)))
  changesInSlope <-
    changesInSlope[changesInSlope$Product<0,]
  returnList <-
    list('changesInSlope' = changesInSlope,
         'changesInConditions' = changesInConditions)
  return(returnList)
}
