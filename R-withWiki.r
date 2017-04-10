fun_withWiki <- function(obj){
library(lubridate)
monthS <-
  c("January","February","March","April","May","June",
    "July","August","September","October","November","December")
USA <-
  paste0('https://en.wikipedia.org/wiki/',year(obj[,1]),'_in_the_United_States#',monthS[month(obj[,1])])
UK <-
  paste0('https://en.wikipedia.org/wiki/',year(obj[,1]),'_in_the_United_Kingdom#',monthS[month(obj[,1])])
JAPAN <-
  paste0('https://ja.wikipedia.org/wiki/',year(obj[,1]),'%E5%B9%B4%E3%81%AE%E6%97%A5%E6%9C%AC#',month(obj[,1]),'.E6.9C.88')
wikiLink <-
  cbind(JAPAN,USA,UK)
wikiLink <-
  apply(wikiLink,2,function(x)paste0('<a href="',x,'" target="_blank">Link</a>'))
assign('dfWithWiki',
       data.frame(obj,wikiLink,stringsAsFactors = F,check.names = F,row.names = NULL),envir = .GlobalEnv)
}
