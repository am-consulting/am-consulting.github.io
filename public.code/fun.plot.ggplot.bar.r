fun.plot.ggplot.bar <- function(load.library = F,obj,col.date = 1,col.data = 2,tail.n = 5*12,y.breaks = 10,lab.caption = '',base.size = 12,subtitle.size = 12,caption.size = 12,axis.size.x = 12,axis.size.y.left = 12,axis.size.y.right = 12,base.family = 'Meiryo',stringize = F,axis.text.x.angle = 0,x.label.date.format = '%Y-%m',x.breaks = 10){
  if(load.library==T){lapply(c('lubridate','ggplot2','scales'),require,character.only = T)}
  obj <- tail(obj[,c(col.date,col.data)],tail.n)
  date.format <- '%Y-%m-%d'
  if(length(unique(month(obj[,1])))==1){date.format <- '%Y'}
  if(length(unique(day(obj[,1])))<=4){date.format <- '%Y-%m'}
  date.range <- paste0(format(range(obj[,1]),date.format),collapse = ' ~ ')
  obj$col <- ifelse(obj[,2]<0,'red','blue')
  if(stringize==T){obj[,1] <- as.character(format(obj[,1],date.format))}
  g <- ggplot(data = obj,aes(x = obj[,1],y = obj[,2]))
  g <- g + theme_grey(base_size = base.size,base_family = base.family)
  g <- g + geom_bar(stat = 'identity',aes(fill = obj$col))
  g <- g + scale_fill_manual(values = c(black = 'black',blue = '#4169e1',red = '#ce5242'))
  g <- g + xlab(label = '')
  g <- g + scale_y_continuous(name = '',breaks = scales::pretty_breaks(y.breaks),
                              labels = function(x)format(x,big.mark = ",",scientific = F))
  if(stringize==F){
    g <- g + scale_x_date(labels = date_format(x.label.date.format),breaks = pretty_breaks(x.breaks))
  }
  g <- g + labs(title = colnames(obj)[2],subtitle = date.range,caption = lab.caption)
  g <- g + theme(legend.position = 'none')
  g <- g + theme(plot.title = element_text(size = base.size,hjust = 0.5))
  g <- g + theme(axis.text.x = element_text(size = axis.size.x,angle = axis.text.x.angle,vjust = 0.5))
  g <- g + theme(axis.text.y = element_text(size = axis.size.y.left,angle = 0))
  g <- g + theme(axis.text.y.right = element_text(size = axis.size.y.right,angle = 0))
  g <- g + theme(plot.subtitle = element_text(size = subtitle.size,angle = 0))
  g <- g + theme(plot.caption = element_text(size = caption.size,angle = 0))
  return(g)
}
