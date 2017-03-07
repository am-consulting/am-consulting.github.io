library(rvest);library(quantmod)
options(scipen = 999)
htmlMarkup <-
  read_html(x = 'http://money.cnn.com/data/dow30/', encoding = 'utf-8')
dow30 <-
  htmlMarkup %>% html_nodes(xpath = "//table[@class = 'wsod_dataTable wsod_dataTableBig']") %>% html_table()
dow30symbols <-
  gsub('(.+?)\\s.+','\\1',dow30[[1]][,1])
dow30company <-
  gsub('.+?\\s(.+)','\\1',dow30[[1]][,1])
symbolsDOW30 <- list()
for(iii in 1:length(dow30symbols)){
  symbolsDOW30[[iii]] <-
    getSymbols(Symbols = dow30symbols[iii],
               auto.assign = F)
}
