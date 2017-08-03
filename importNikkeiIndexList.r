library(rvest)
targetHTML <- 'https://indexes.nikkei.co.jp/en/nkave/index?type=download'
htmlMarkup <- read_html(x = targetHTML,encoding = 'utf8')
divList <-
  htmlMarkup %>% html_nodes(xpath = "//div[@class = 'row list-row dashed-top list-hover']")
divList <- divList[grep('daily_en.csv',divList)]
divList %>% html_text()
NikkeiDailyIndexList <- data.frame()
baseURL <- 'https://indexes.nikkei.co.jp/en'
for(iii in seq(length(divList))){
  buf <- divList[[iii]] %>% html_nodes('div') %>% html_nodes('a')
  NikkeiDailyIndexList[iii,1] <- iii
  NikkeiDailyIndexList[iii,2] <- buf[grep('list-title font-16 divlink',buf)] %>% html_text()
  NikkeiDailyIndexList[iii,3] <- paste0(baseURL,
                                        gsub('.+href=\'([^;]+\\.csv).+','\\1',
                                             buf[grep('daily_en.csv',buf)] %>% html_attr('onclick')))
}
