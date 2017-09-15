fun.plot.ggplot.ann.rect <- function(xmin,xmax,ymin=-Inf,ymax=Inf,alpha=0.1,fill='red'){
  g <- g + annotate('rect',xmin = xmin,xmax = xmax,ymin = ymin,ymax = ymax,alpha = alpha,fill = fill)
  return(g)
}

fun.plot.ggplot.ann.text <- function(x,y=Inf,lable,angle=0,vjust=1,hjust=0,size=7,col='black',family='Meiryo'){
  g <- g + annotate('text',x = x,y = y,label = label,angle = angle,vjust = vjust,hjust = hjust,size = size,col = col,family = family)
  return(g)
}

fun.plot.ggplot.vline <- function(xintercept,col='red',linetype=2){
  g <- g + geom_vline(xintercept = xintercept,col = col,linetype = linetype)
  return(g)
}

fun.plot.ggplot.hline <- function(yintercept,col='red',linetype=2){
  g <- g + geom_vline(yintercept = xintercept,col = col,linetype = linetype)
  return(g)
}

fun.plot.ggplot.text.repel <- function(data,size=6){
  g <- g + geom_text_repel(data = data,aes(x = data[,1],y = data[,2],label = data[,2]),size = size)
  return(g)
}
