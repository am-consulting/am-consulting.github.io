library(dygraphs)
fun_dygraphPlot <- function(tsData,mainTitle = '',name = 'Dark2',group = 0,show = c("auto","always","onmouseover","follow","never"),width = 250,direction = c("both","horizontal","vertical"),maxNumberWidth = 100,axis = c("y","y2"),pointSize = 2,drawPoints = TRUE){
  xtsData <- xts(tsData[,-1],order.by = tsData[,1])
  colnames(xtsData) <- colnames(tsData)[-1]
  colors <- RColorBrewer::brewer.pal(n = ncol(xtsData),name = name)
  drawPoints <- rep(x = TRUE,ncol(tsData))
  pointSize <- rep(x = pointSize,ncol(tsData))
  if(group == 1){
    obj <- dygraph(xtsData,main = mainTitle,group = 'amcc')
  }else{
    obj <- dygraph(xtsData,main = mainTitle)
  }
  for(ccc in seq(ncol(xtsData))){
    obj <- obj %>%
      dySeries(colnames(xtsData)[ccc],drawPoints = drawPoints[ccc],pointSize = pointSize[ccc],axis = axis[ccc],color = colors[ccc])
    # length(axis)よりncol(xtsData)が大きいとError in match.arg(axis, c("y", "y2")):'arg' should be one of “y”, “y2”がでる
  }
  if(length(unique(axis))!=1){
    labelY <- paste0(colnames(xtsData)[grep('y$',axis)],collapse = ',')
    labelY2 <- paste0(colnames(xtsData)[grep('y2',axis)],collapse = ',')
    obj <- obj %>%
      dyAxis("y",label = labelY) %>%
      dyAxis("y2",label = labelY2,independentTicks = T)
  }
  obj <- obj %>%
    dyLegend(show = show,width = width,showZeroValues = 'TRUE',labelsSeparateLines = 'TRUE',hideOnMouseOut = 'FALSE') %>%
    dyRangeSelector(keepMouseZoom = 'TRUE',retainDateWindow = 'FALSE') %>%
    dyUnzoom() %>%
    dyCrosshair(direction = direction) %>%
    dyOptions(maxNumberWidth = maxNumberWidth)
  return(obj)
}
