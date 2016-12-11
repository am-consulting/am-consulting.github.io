library(rvest);library(XLConnect);library(XML)
url0 <- 'https://www.cia.gov/library/publications/the-world-factbook/rankorder/rankorderguide.html'
htmlMarkup0 <- read_html(url0, encoding = "utf8")
# htmlMarkup <- htmlParse(url)
# links <- xpathSApply(htmlMarkup, "//a/@href")
# Warning message:XML content does not seem to be XML:'https://www.cia.gov/library/publications/the-world-factbook/rankorder/rankorderguide.html'
linkLists <- htmlMarkup0 %>% html_nodes(xpath = "//a") %>% html_attr("href")
linkLists <- linkLists[grep('/rankorder/[0-9]{4}',linkLists,ignore.case = T)]
tableTitle <- subtableTitle <- vector()
for(iii in 1:length(linkLists)){
  htmlMarkup1 <-
    read_html(paste0('https://www.cia.gov/library/publications/the-world-factbook',gsub('\\.\\.','',linkLists[iii])),
              encoding = "utf8")
  comparisonTable <-
    htmlMarkup1 %>% html_nodes(xpath = "//table") %>% html_table()
  assign(paste0('comparisonTable',iii),comparisonTable[[1]],envir = .GlobalEnv)
  tableTitle <-
    c(tableTitle,
      htmlMarkup1 %>% html_nodes(xpath = "//div") %>% html_nodes(css = ".fbTitleRankOrder") %>% html_nodes(xpath = "//strong") %>% html_text())
  subtableTitle <-
    c(subtableTitle,
    htmlMarkup1 %>% html_nodes(xpath = "//div") %>% html_nodes(css = ".rankOrderDesc") %>% html_text())
}
assign('tableTitle',tableTitle,envir = .GlobalEnv)
assign('subtableTitle',subtableTitle,envir = .GlobalEnv)
