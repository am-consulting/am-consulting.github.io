fun.plot.ggplot.boxplot <- function(obj,y.breaks = 10,lab.caption = '',base.size = 11,subtitle.size = 11,caption.size = 11,axis.size = 10,base.family = 'Meiryo'){
  return.list <- fun.date.format(obj = obj)
  obj$year <- year(obj$Date)
  obj$month <- month(obj$Date)
  g <-
    ggboxplot(data = obj,x = colnames(obj)[3],y = colnames(obj)[2],color = colnames(obj)[3],
              palette = "UChicago",add = "jitter",
              ggtheme = theme_gray(base_size = base.size,base_family = 'Meiryo'),repel = T)
  g <- g + xlab('') + theme(legend.position = "none")
  g <- g + scale_y_continuous(name = '',breaks = scales::pretty_breaks(y.breaks),sec.axis = dup_axis())
  g <- g + labs(title = colnames(obj)[2], subtitle = return.list$date.range,caption = lab.caption)
  g <- g + theme(plot.title = element_text(hjust = 0.5))
  g <- g + theme(plot.subtitle = element_text(size = subtitle.size,angle = 0))
  g <- g + theme(plot.caption = element_text(size = caption.size,angle = 0))
  g <- g + theme(axis.text.x = element_text(size = axis.size,angle = 0))
  g <- g + theme(axis.text.y = element_text(size = axis.size,angle = 0))
  print(g)
}
