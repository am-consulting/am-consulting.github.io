fun.create.html.table <- function(obj,table.attr = "width = '100%' class = 'table'",order.col = 1,decreasing = F,scientific = F,escape = F){
  obj <- obj[order(obj[,order.col],decreasing = decreasing),,drop = F]
  col.date <- which(lapply(obj,class)=='Date')
  col.factior <- which(lapply(obj,class)=='factor')
  obj[,c(col.date,col.factior)] <-as.character(obj[,c(col.date,col.factior)])
  buf <- ''
  for(rrr in seq(nrow(obj))){
    obj.col <- setdiff(which(!is.na(as.numeric(obj[rrr,]))),col.date)
    obj[rrr,obj.col] <- format(as.numeric(obj[rrr,obj.col]),big.mark = ',',scientific = scientific)
    buf <- paste0(buf,paste0('<tr>',paste0(paste0('<td>',obj[rrr,],'</td>'),collapse = ''),'</tr>\n'))
  }
  table.tb <- paste0('<tbody>\n',buf,'</tbody>')
  table.th <- paste0('<thead>\n<tr>',paste0(paste0('<th>',colnames(obj),'</th>'),
                                          collapse = ''),'</tr>\n</thead>\n')
  table.top <- paste0('<table ',table.attr,'>\n')
  table.bottom <- '\n</table>\n'
  table.html <-  paste0(table.top,table.th,table.tb,table.bottom)
  if(escape == T){table.html <- htmltools::htmlEscape(text = table.html, attribute = F)}
  return(table.html)
}
