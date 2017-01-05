library(RCurl);library(rvest);library(Nippon)
options(scipen = 999)
sourceURL <-
  'https://www.boj.or.jp/statistics/boj/other/acmai/index.htm/'
htmlMarkup <-
  getURL(sourceURL, ssl.verifyPeer = F, .encoding = "utf-8")
pattern <-
  "/statistics/boj/other/acmai/release/[0-9]{4}.*?\\.htm"
pageList <-
  regmatches(htmlMarkup, gregexpr(pattern, htmlMarkup, fixed = F))
pageList <-
  unique(unlist(pageList))
pageList <-
  paste0('https://www.boj.or.jp',pageList)
Assets <- LiabilitiesAndNetWorth <- JGBbreakdown <- list()
for(iii in 1:length(pageList)){
  sourceURL <-
    paste0(pageList[iii],'/')
  htmlMarkup <-
    read_html(sourceURL,
              encoding = "utf-8")
  tableList <-
    htmlMarkup %>% html_nodes(xpath = "//table") %>% html_table()
  tableTitle <-
    htmlMarkup %>% html_nodes(xpath = "//title") %>% html_text()
  tableTitle <-
    gsub('\\s','',zen2han(substring(tableTitle,1,(regexpr(':', tableTitle)-1))))
  # 資産パート
  buf <-
    tableList[[1]]
  buf[,1] <-
    gsub('[0-9]','',buf[,1])
  buf[,2] <-
    sapply(buf[,2],function(x)as.numeric(gsub(',','',x))*10^-9)
  colnames(buf) <-
    c(paste0('資産:',tableTitle),'金額(兆円)')
  buf <-
    data.frame(buf, `構成比(%)` = round(buf[,2]/buf[nrow(buf),2]*100,2),
               check.names = F, stringsAsFactors = F)
  Assets[[iii]] <- buf
  # 負債パート
  buf <-
    tableList[[2]]
  buf[,1] <-
    gsub('[0-9]','',buf[,1])
  buf[,2] <-
    sapply(buf[,2],function(x)as.numeric(gsub(',','',x))*10^-9)
  colnames(buf) <-
    c(paste0('負債及び純資産:',tableTitle),'金額(兆円)')
  buf <-
    data.frame(buf, `構成比(%)` = round(buf[,2]/buf[nrow(buf),2]*100,2),
               check.names = F, stringsAsFactors = F)
  LiabilitiesAndNetWorth[[iii]] <- buf
  # 国債内訳パート
  buf <-
    tableList[[3]]
  buf[,1] <-
    gsub('[0-9]','',buf[,1])
  buf[,2] <-
    sapply(buf[,2],function(x)as.numeric(gsub(',','',x))*10^-9)
  colnames(buf) <-
    c(paste0('国債内訳:',tableTitle),'金額(兆円)')
  buf <-
    data.frame(buf, `構成比(%)` = round(buf[,2]/sum(buf[,2])*100,2),
               check.names = F, stringsAsFactors = F)
  JGBbreakdown[[iii]] <- buf
}
