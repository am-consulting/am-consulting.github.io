library(rvest);library(Nippon)
options(scipen = 999)
htmlMarkup <-
  read_html(x = 'http://www.mof.go.jp/international_policy/reference/feio/monthly/index.htm',
            encoding = 'shift_jis')
aS <-
  htmlMarkup %>% html_nodes('.singleBlock') %>% html_nodes('a')
aS <-
  aS[grep('\\.htm',aS,ignore.case = T)]
htmList <-
  data.frame(aS %>% html_text(),aS %>% html_attr('href'),stringsAsFactors = F)
iii<-1
for(iii in 1:nrow(htmList)){
  url <-
    paste0('http://www.mof.go.jp/international_policy/reference/feio/monthly/', htmList[iii,2])
  htmlMarkup <-
    tryCatch(expr = read_html(x = url,
                       encoding = 'shift_jis'),
             error = function(e){conditionMessage(e)})
  if(class(htmlMarkup)[1] != 'character'){
    Intervention  <-
      htmlMarkup %>% html_nodes('.singleBlock') %>% html_text()
    if(length(Intervention) == 0){
      Intervention <-
        htmlMarkup %>% html_table()
    }
    buf <- gsub('\t|\n|<U+00A0>','',unlist(Intervention))
    tmp0 <- regexpr("外国為替平衡操作額|外国為替平衡操額", buf)
    tmp0 <- substring(text = buf, first = tmp0 + attr(tmp0, "match.length"))
    tmp1 <- regexpr("円", tmp0)
    tmp1 <- substring(text = tmp0, first = 1, last = tmp1)
    htmList[iii,3] <-
      gsub('\\s','', tmp1)
  }else{
    htmList[iii,3] <- htmlMarkup
  }
}
htmList0 <- htmList
objRow <-
  grep('兆|億',htmList0[,3])
htmList0[objRow,3] <-
  gsub('円|億|,','',htmList0[objRow,3])
buf0 <-
  as.numeric(substring(text = htmList0[objRow,3],
                       first = 1,
                       last =  regexpr('兆',htmList0[objRow,3]) - 1)) * 10^12
buf0[is.na(buf0)] <- 0
buf1 <-
  as.numeric(substring(text = htmList0[objRow,3],
                       first =  regexpr('兆',htmList0[objRow,3]) + 1)) * 10^8
buf1[is.na(buf1)] <- 0
htmList0[objRow,3] <- buf0 + buf1
htmList0[,3] <-
  gsub('円','',htmList0[,3])
htmList0[,1] <-
  gsub('\\s','',sapply(htmList0[,1],zen2han))
tmp <- as.numeric(htmList0[,3])*10^-8
htmList0[!is.na(tmp),3] <- tmp[!is.na(tmp)]
htmList0[,2] <-
  paste0('<a href="http://www.mof.go.jp/international_policy/reference/feio/monthly/',
         htmList0[,2],
         '" target="_blank">',
         htmList0[,2],
         '</a>')
colnames(htmList0) <-
  c('期間','URL','外国為替平衡操作額(億円)')
assign('ForeignExchangeIntervention',htmList0,envir = .GlobalEnv)
