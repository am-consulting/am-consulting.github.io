fun.html.table <- function(obj,table.attr = "width = '100%' class = 'amccrespontable'"){
  buf <- ''
  for(rrr in seq(nrow(obj))){
    obj.col <- !is.na(as.numeric(obj[rrr,]))
    obj[rrr,obj.col] <- format(obj[rrr,obj.col],big.mark=',',scientific=F)
    buf <- paste0(buf,paste0('<tr>',paste0(paste0('<td>',obj[rrr,],'</td>'),collapse = ''),'</tr>\n'))
  }
  table.tb <- paste0('<tbody>\n',buf,'</tbody>')
  table.th <- paste0('<thead>\n<tr>',paste0(paste0('<th>',colnames(obj),'</th>'),
                                          collapse = ''),'</tr>\n</thead>\n')
  table.top <- paste0('<table ',table.attr,'>\n')
  table.bottom <- '\n</table>\n'
  table.html <-  paste0(table.top,table.th,table.tb,table.bottom)
  return(table.html)
}
