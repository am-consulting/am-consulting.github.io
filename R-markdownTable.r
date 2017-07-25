fun_markdownTable <-
  function(obj, rownames = F, table.attr = "width = '100%' class = 'amcc'", format = 'html', escape = F){
  kableText <-
    knitr::kable(obj,
                 row.names = rownames,
                 align = 'r',
                 format = format,
                 format.args = list(big.mark = ',', drop0trailing = T),
                 table.attr = table.attr,
                 escape = escape)
  cat('\n<div class = "amccTableAutoScroll">\n')
  print(kableText)
  cat('\n</div>\n')
}
