fun.read.from.fred <- function(load.library = F,index = 'Dow Jones Industrial Average (DJIA)'){
  if(load.library==T){lapply(c('quantmod','rvest'),require,character.only = T)}
  Sys.sleep(1) # To prevent server overload
  index.title <-
    gsub('(.+)\\((.+)\\)','\\1',index)
  index.symbol <-
    gsub('(.+)\\((.+)\\)','\\2',index)
  data.set.xts <-
    na.omit(getSymbols(Symbols = index.symbol,auto.assign = F,src = 'FRED'))
  index.url <-
    paste0('https://fred.stlouisfed.org/series/',index.symbol)
  html.markup <-
    read_html(x = index.url,encoding = 'utf8')
  index.spec <-
    html.markup %>% html_nodes(xpath = "//span[@class = 'series-meta-value']")
  index.unit <-
    index.spec[[grep('units',index.spec,ignore.case = T)[1]]] %>% html_text()
  index.unit <-
    gsub('\\s+$','',index.unit)
  index.freq <-
    index.spec[[grep('frequency',index.spec,ignore.case = T)[1]]] %>% html_text()
  index.freq <-
    gsub('\\s|\n','',index.freq)
  returnList <-
    list('data.set.xts' = data.set.xts,
         'index.unit' = index.unit,
         'index.freq' = index.freq,
         'index.title' = index.title)
  return(returnList)
}
