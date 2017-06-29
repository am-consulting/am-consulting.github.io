library(rvest)
OICA <- list()
objYear <- seq(1999,2016)
cnt <- 1
for(yyyy in objYear){
  if(yyyy==tail(objYear,1)){
    targetURL <-
      'http://www.oica.net/category/production-statistics/'
    htmlMarkup <-
      read_html(x = targetURL,encoding = 'utf8')
  }else{
    htmlMarkup <-
      read_html(x = paste0(targetURL,yyyy,'-statistics/'),encoding = 'utf8')
  }
  dataDF <-
    data.frame(htmlMarkup %>% html_nodes('table') %>% html_table(),
               check.names = F,stringsAsFactors = F)
  dataDF[,-1] <-
    apply(dataDF[,-1],2,function(x)as.numeric(gsub(',|%','',x)))
  dataDF$Year <- yyyy
  OICA[[cnt]] <- dataDF
  print(head(OICA[[cnt]]))
  cnt <- cnt + 1
}
