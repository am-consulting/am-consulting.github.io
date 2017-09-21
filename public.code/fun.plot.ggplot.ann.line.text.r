fun.plot.ggplot.ann.rect <- function(xmin,xmax,ymin=-Inf,ymax=Inf,alpha=0.1,fill='red'){
  g <- g + annotate('rect',xmin = xmin,xmax = xmax,ymin = ymin,ymax = ymax,alpha = alpha,fill = fill)
  return(g)
}

fun.plot.ggplot.ann.text <- function(x,y=Inf,lable,angle=0,vjust=1,hjust=0,size=7,col='black',family='Meiryo'){
  g <- g + annotate('text',x = x,y = y,label = label,angle = angle,vjust = vjust,hjust = hjust,size = size,col = col,family = family)
  return(g)
}

fun.plot.ggplot.vline <- function(xintercept,col='#696969',linetype=2){
  g <- g + geom_vline(xintercept = xintercept,col = col,linetype = linetype)
  return(g)
}

fun.plot.ggplot.hline <- function(yintercept,col='#696969',linetype=2){
  g <- g + geom_hline(yintercept = yintercept,col = col,linetype = linetype)
  return(g)
}

fun.plot.ggplot.text.repel <- function(data,size=6,load.library=F,col='#696969'){
  if(load.library==T){lapply(c('ggrepel','tidyr'),require,character.only = T)}
  gathered.df <- gather(data = data,key = Index,value = Value,colnames(data)[-1],convert = T)
  assign('gathered.df',gathered.df,envir = .GlobalEnv)
  g <- g + geom_text_repel(data = gathered.df,
                           aes(x = gathered.df[,1],y = gathered.df[,3],label = gathered.df[,3]),
                           size = size,col = col)
  remove(gathered.df)
  return(g)
}

fun.plot.ggplot.encircle <- function(data,size=1,expand=0.1,color='red',legend=F){
  g <- g + geom_encircle(data = data,aes(x = data$x, y = data$y),show.legend = legend,
                         color = color,size = size,expand = expand)
  return(g)
}

fun.plot.ggplot.mean.median.hline <- function(obj,date.col=1,data.col=2,col='#696969',linetype=2,angle=0,vjust=0,hjust=0,size=4){
  g <- g + geom_hline(yintercept = mean(obj[,data.col]),col = col,linetype = linetype)
  g <- g + geom_hline(yintercept = median(obj[,data.col]),col = col,linetype = linetype)
  g <- g + annotate('text',x = min(obj[,date.col]),y = mean(obj[,data.col]),label = 'Mean',
                    angle = angle,vjust = vjust,hjust = hjust,size = size,col = col,family = family)
  g <- g + annotate('text',x = min(obj[,date.col]),y = median(obj[,data.col]),label = 'Median',
                    angle = angle,vjust = vjust,hjust = hjust-1,size = size,col = col,family = family)
  return(g)
}
