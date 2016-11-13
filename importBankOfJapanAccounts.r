library(RCurl)
sourceURL <- 'https://www.boj.or.jp/statistics/boj/other/acmai/'
htmlMarkup <- iconv(getURL(sourceURL, ssl.verifyPeer = F, .encoding = "shift_jis"), "shift_jis", "UTF-8")
pattern <- "/statistics/boj/other/acmai/release/.*?\\.htm"
pageList <- regmatches(htmlMarkup, gregexpr(pattern, htmlMarkup, fixed = F))
pageList <- unlist(pageList)
pageList <- paste0('https://www.boj.or.jp',pageList)
sourceURL <- paste0(pageList[1],'/')
htmlMarkup <- iconv(getURL(sourceURL, ssl.verifyPeer = F, .encoding = "shift_jis"), "shift_jis", "UTF-8")
pattern <- "(<th.*?>)+?.*?</td>"
data <- gsub('\n','',unlist(regmatches(htmlMarkup, gregexpr(pattern, htmlMarkup, fixed = F))))
data <- gsub("<sup>.*?</sup>",'',data)
data <- data[1:grep('合計',data)[2]]
tmp1 <- gsub('<th>|</th>','',unlist(regmatches(data, gregexpr('<th>.*?</th>', data, fixed = F))))
tmp2 <- gsub('<td>|</td>','',unlist(regmatches(data, gregexpr('<td>.*?</td>', data, fixed = F))))
tmp2 <- as.numeric(gsub(',','',tmp2))*10^-9
data <- data.frame(tmp1,tmp2)
Assets <- data[1:grep('合計',data[,1])[1],]
colnames(Assets) <- c('資産','金額(兆円)')
LiabilitiesAndNetWorth <- data[(grep('合計',data[,1])[1]+1):nrow(data),]
colnames(LiabilitiesAndNetWorth) <- c('負債および純資産','金額(兆円)')
pattern <- "<title>.*?</title>"
title <- gsub('<title>|</title>','',unlist(regmatches(htmlMarkup, gregexpr(pattern, htmlMarkup, fixed = F))))
Assets <- data.frame(Assets,`構成比(%)`=round(Assets[,2]/Assets[nrow(Assets),2]*100,2), check.names = F)
LiabilitiesAndNetWorth <-
  data.frame(LiabilitiesAndNetWorth,
             `構成比(%)`=round(LiabilitiesAndNetWorth[,2]/LiabilitiesAndNetWorth[nrow(LiabilitiesAndNetWorth),2]*100,2),
             check.names = F)