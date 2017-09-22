fun.plot.ggplot.cabinet <- function(g,obj,date.col = 1,ann.size.cabinet = 5){
  x.min <- c(as.Date('2009-9-16'),as.Date('2012-12-26'))
  x.max <- c(tail(x.min,-1),tail(obj[,date.col],1))
  fill.col <- c('red','blue')
  annotion.txt <- c('民主党政権','第2次安倍政権発足以降')
  g <- fun.plot.ggplot.ann.rect(g = g,xmin = x.min,xmax = x.max,fill = fill.col)
  g <- fun.plot.ggplot.ann.text(g = g,x = x.min,label = annotion.txt,size = ann.size.cabinet)
  return(g)
}

fun.plot.ggplot.event <- function(g,obj,date.col = 1,ann.size.event = 5){
  event <-
    c(
      '2008-9-15','リーマンショック',
      '2012-12-16','第46回衆議院選挙',
      '2011-3-11','東北大震災',
      '2014-4-1','消費税増税(8%)',
      '2014-12-14','第47回衆議院選挙',
      '2016-11-8','2016年アメリカ合衆国大統領選挙',
      '2017-1-20','トランプ大統領政権発足',
      '2016-7-10','第24回参議院選挙'
      )
  event.date <- as.Date(event[seq(1,length(event),by=2)])
  event.name <- event[seq(2,length(event),by=2)]
  event.df <- data.frame(event.date,event.name,stringsAsFactors = F)
  event.df <- event.df[order(event.df[,1],decreasing = F),]
  check.range <- head(obj[,date.col],1)<=event.df[,1]
  g <- fun.plot.ggplot.vline(g = g,xintercept = event.df[check.range,1])
  g <- fun.plot.ggplot.ann.text(g = g,x = event.df[check.range,1],
                                label = paste0(' ',event.df[check.range,2]),
                                y = -Inf,angle = 90,vjust = 0,hjust = 0,size = ann.size.event)
  return(g)
}
