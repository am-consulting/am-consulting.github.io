fun.plot.ggplot.timeseries <- function(load.library = F,obj,col.date = 1,x.breaks = 10,y.breaks = 10,lab.title = '',lab.caption = '',x.label.date.format = '%Y',base.size = 11,subtitle.size = 11,caption.size = 11,axis.size.x = 10,axis.size.y.left = 10,axis.size.y.right = 10,manual.color = NULL,base.family = 'Meiryo',hline = F,point = T,point.size = 1,remove.legend.title = T,legend.size = 11){
  if(load.library==T){lapply(c('tidyr','lubridate','ggplot2'),require,character.only = T)}
  colnames(obj)[col.date] <- 'Date'
  obj <- gather(data = obj,key = Index,value = Value,colnames(obj)[-col.date],convert = T)
  date.format <- '%Y-%m-%d'
  if(length(unique(month(obj$Date)))==1){date.format <- '%Y'}
  if(length(unique(day(obj$Date)))<=4){date.format <- '%Y-%m'}
  date.range <- paste0(format(range(obj$Date),date.format),collapse = ' ~ ')
  g <- ggplot(data = obj,aes(x = Date,y = Value,col = Index))
  g <- g + theme_grey(base_size = base.size,base_family = base.family)
  g <- g + geom_line() + geom_smooth(size = 0.5)
  g <- g + scale_x_date(labels = scales::date_format(x.label.date.format),breaks = scales::pretty_breaks(x.breaks))
  g <- g + xlab(label = '')
  g <- g + scale_y_continuous(name = '',breaks = scales::pretty_breaks(y.breaks),
                              labels = function(x)format(x,big.mark = ",",scientific = F))
  g <- g + labs(title = lab.title,subtitle = date.range,caption = lab.caption)
  g <- g + theme(legend.position = 'top')
  g <- g + theme(plot.title = element_text(size = base.size,hjust = 0.5))
  g <- g + theme(axis.text.x = element_text(size = axis.size.x,angle = 0))
  g <- g + theme(axis.text.y = element_text(size = axis.size.y.left,angle = 0))
  g <- g + theme(axis.text.y.right = element_text(size = axis.size.y.right,angle = 0))
  g <- g + theme(plot.subtitle = element_text(size = subtitle.size,angle = 0))
  g <- g + theme(plot.caption = element_text(size = caption.size,angle = 0))
  g <- g + theme(legend.text = element_text(size = legend.size))
  if(length(unique(obj$Index)) <= length(manual.color)){
    if(remove.legend.title == T){
      g <- g + scale_color_manual('',values = manual.color)
    }else{
      g <- g + scale_color_manual(values = manual.color)
    }
  }
  if(point == T){
    g <- g + geom_point(size = point.size)
  }
  if(hline == T){
    g <- g + geom_hline(yintercept = 0,col = '#c0c0c0')
  }
  return(g)
}
