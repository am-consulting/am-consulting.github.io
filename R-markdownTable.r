fun_markdownTable <- function(obj, rownames = F, table.attr = "id = 'amcc' width = '100%'", format = 'markdown'){
  kableText <-
    knitr::kable(obj,
                 row.names = rownames,
                 align = 'r',
                 format = format,
                 format.args = list(big.mark = ',', drop0trailing = T),
                 table.attr = table.attr)
  cat('\n<div class = "amccTableAutoScroll">\n')
  print(kableText)
  cat('\n</div>\n')
}
