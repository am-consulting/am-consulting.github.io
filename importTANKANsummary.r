# https://www.r-bloggers.com/web-scraping-and-invalid-multibyte-string/
library(rvest)
library(Nippon)
Sys.setlocale("LC_ALL","English")
Sys.getlocale()
htmlMarkup <-
  read_html(x = targetURL,encoding = 'utf8')
tableList <-
  htmlMarkup %>% html_nodes('table')
captionList <- vector()
TANKANsummary <- list()
for(iii in seq(length(tableList))){
  captionList[iii] <-
    gsub('\n','',zen2han(tableList[[iii]] %>%  html_nodes('caption') %>% html_text()))
  TANKANsummary[[iii]] <-
    data.frame(tableList[[iii]] %>% html_table(fill=T),stringsAsFactors = F,check.names = F)
  colnames(TANKANsummary[[iii]])[1] <- ''
}
Sys.setlocale("LC_ALL","Japanese")
for(iii in seq(length(TANKANsummary))){
  print(captionList[iii])
  print(TANKANsummary[[iii]])
}
