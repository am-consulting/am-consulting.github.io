library(dygraphs)
library(xts)
fun_dygraphPlot <- function(tsData,mainTitle = '',name = 'Dark2',group = 0,show = c("auto","always","onmouseover","follow","never"),width = 250,direction = c("both","horizontal","vertical"),maxNumberWidth = 100,axis = c("y","y"),drawPoints = c(TRUE,TRUE),pointSize = c(2,2),fillGraph = c(TRUE,FALSE),shadePattern = c(seq(8)),strawBroom = 0){
  xtsData <- xts(tsData[,-1],order.by = tsData[,1])
  colnames(xtsData) <- colnames(tsData)[-1]
  colors <- RColorBrewer::brewer.pal(n = ncol(xtsData),name = name)
  if(group == 1){
    obj <- dygraph(xtsData,main = mainTitle,group = 'amcc')
  }else{
    obj <- dygraph(xtsData,main = mainTitle)
  }
  for(ccc in seq(ncol(xtsData))){
    obj <- obj %>%
      dySeries(colnames(xtsData)[ccc],drawPoints = drawPoints[ccc],
               pointSize = pointSize[ccc],axis = axis[ccc],color = colors[ccc],
               fillGraph = fillGraph[ccc])
    # length(axis)よりncol(xtsData)が大きいと、
    # Error in match.arg(axis, c("y", "y2")):'arg' should be one of “y”, “y2”がでる
  }
  if(length(unique(axis))!=1){
    labelY <- paste0(colnames(xtsData)[grep('y$',axis)],collapse = ',')
    labelY2 <- paste0(colnames(xtsData)[grep('y2',axis)],collapse = ',')
    obj <- obj %>%
      dyAxis("y",label = labelY) %>%
      dyAxis("y2",label = labelY2,independentTicks = T)
  }
  obj <- obj %>%
    dyLegend(show = show,width = width,showZeroValues = 'TRUE',
             labelsSeparateLines = 'TRUE',hideOnMouseOut = 'TRUE') %>%
    dyRangeSelector(keepMouseZoom = 'TRUE',retainDateWindow = 'FALSE') %>%
    dyUnzoom() %>%
    dyCrosshair(direction = direction) %>%
    dyOptions(maxNumberWidth = maxNumberWidth,pointSize = pointSize)
  if(strawBroom == 1){obj <- obj %>% dyRebase(percent = T)}
  fun_consumptionTax(obj = tsData)
  fun_primeMinisterOfJapan(obj = tsData)
  fun_boj(obj = tsData)
  fun_event(obj = tsData)
  fun_potus(obj = tsData)
  fun_frb(obj = tsData)
  fun_eventE(obj = tsData)
  dygraphTxt <-
    switch(shadePattern,
           obj,
           eval(parse(text = paste0('obj',' %>% ',ConsumptionTax))),
           eval(parse(text = paste0('obj',' %>% ',primeMinisterOfJapan_dygraph))),
           eval(parse(text = paste0('obj',' %>% ',boj_dygraph))),
           eval(parse(text = paste0('obj',' %>% ',potus_dygraph))),
           eval(parse(text = paste0('obj',' %>% ',frb_dygraph))),
           eval(parse(text = paste0('obj',' %>% ',event_dygraph_point))),
           eval(parse(text = paste0('obj',' %>% ',eventE_dygraph_point))))
  return(dygraphTxt)
}
# fun_dygraphPlot(tsData = tsData[,c(1,2)],shadePattern = 7)
