fun.plot.ggplot.timeseries <- function(obj,col.date = 1,x.breaks = 10,y.breaks = 10,lab.title = '',lab.caption = '',x.label.date.format = '%Y',base.size = 11,subtitle.size = 11,caption.size = 11,axis.size = 10,manual.color = NULL,base.family = 'Meiryo'){
  colnames(obj)[col.date] <- 'Date'
  obj <- gather(data = obj,key = Index,value = Value,colnames(obj)[-col.date],convert = T)
  date.format <- '%Y-%m-%d'
  if(length(unique(month(obj$Date)))==1){date.format <- '%Y'}
  if(length(unique(day(obj$Date)))<=4){date.format <- '%Y-%m'}
  date.range <- paste0(format(range(obj$Date),date.format),collapse = ' ~ ')
  g <- ggplot(data = obj,aes(x = Date,y = Value,col = Index))
  g <- g + theme_grey(base_size = base.size,base_family = base.family)
  g <- g + geom_line() + geom_smooth()
  g <- g + scale_x_date(labels = scales::date_format(x.label.date.format),breaks = scales::pretty_breaks(x.breaks))
  g <- g + xlab(label = '') + scale_y_continuous(name = '',breaks = scales::pretty_breaks(y.breaks),sec.axis = dup_axis())
  g <- g + labs(title = lab.title,subtitle = date.range,caption = lab.caption)
  g <- g + geom_hline(yintercept = 0,col = '#c0c0c0')
  g <- g + theme(legend.position = 'top')
  g <- g + theme(plot.title = element_text(size = base.size,hjust = 0.5))
  g <- g + theme(axis.text.x = element_text(size = axis.size,angle = 0))
  g <- g + theme(axis.text.y = element_text(size = axis.size,angle = 0))
  g <- g + theme(plot.subtitle = element_text(size = subtitle.size,angle = 0))
  g <- g + theme(plot.caption = element_text(size = caption.size,angle = 0))
  if(length(unique(obj$Index))<=length(manual.color)){
    g <- g + scale_color_manual(values = manual.color)
  }
  print(g)
}
