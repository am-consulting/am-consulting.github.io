fun_markdownTable <- function(obj){
  knitr::kable(obj,
               row.names = F,
               align = 'r',
               format = 'markdown',
               format.args = list(big.mark = ',', drop0trailing = T))
}
