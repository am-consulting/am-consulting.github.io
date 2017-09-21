fun.plot.ggplot.cabinet <- function(g,ann.size.cabinet = 5,ann.size.event = 5){
  x.min <- c(as.Date('2009-9-16'),as.Date('2012-12-26'))
  x.max <- c(tail(x.min,-1),tail(obj[,1],1))
  fill.col <- c('red','blue')
  annotion.txt <- c('民主党政権','第2次安倍政権発足以降')
  event.date <- c(as.Date('2008-9-15'),as.Date('2012-12-16'),as.Date('2011-3-11'),as.Date('2014-4-1'),as.Date('2014-12-14'))
  event.name <- c('リーマンショック','第46回衆議院選挙','東北大震災','消費税増税(8%)','第47回衆議院選挙')
  g <- fun.plot.ggplot.ann.rect(g = g,xmin = x.min,xmax = x.max,fill = fill.col)
  g <- fun.plot.ggplot.ann.text(g = g,x = x.min,label = annotion.txt,size = ann.size.cabinet)
  g <- fun.plot.ggplot.vline(g = g,xintercept = event.date)
  g <- fun.plot.ggplot.ann.text(g = g,x = event.date,label = paste0(' ',event.name),y = -Inf,
                                angle = 90,vjust = 0,hjust = 0,size = ann.size.event)
  return(g)
}
