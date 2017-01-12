fun_markdownTable <- function(obj, rownames = F){
  knitr::kable(obj,
               row.names = rownames,
               align = 'r',
               format = 'markdown',
               format.args = list(big.mark = ',', drop0trailing = T))
}
