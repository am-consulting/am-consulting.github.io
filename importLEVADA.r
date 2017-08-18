library(rvest)
targetHTML <- 'https://www.levada.ru/en/ratings/'
htmlMarkup <- read_html(x = targetHTML,encoding = 'utf8')
titleList <- htmlMarkup %>% html_nodes('h4') %>% html_text()
tableList <- htmlMarkup %>% html_nodes('table')
tablePart <- grep('datatable',tableList)
headPart <- seq(length(tableList))[-tablePart]
tableDF <- tableList %>% html_table()
cnt <- 0
levada <- list()
for(iii in headPart){
  buf <- cbind(tableDF[[iii]],tableDF[[iii+1]])
  mm <-  gsub('(\\d+)\\.(\\d+)','\\1',buf[1,])
  yyyy <- as.numeric(gsub('(\\d+)\\.(\\d+)','\\2',buf[1,]))
  yyyy <- yyyy * 10^(4-nchar(yyyy))
  buf[1,] <- paste0(yyyy,'-',mm,'-1')
  tmp <- data.frame(t(buf),stringsAsFactors = F,check.names = F,row.names = NULL)
  colnames(tmp) <- tmp[1,]
  tmp <- tmp[-1,]
  colnames(tmp)[1] <- 'Date'
  row.names(tmp) <- NULL
  tmp[,1] <- as.Date(tmp[,1])
  tmp[,-1] <- apply(tmp[,-1,drop=F],2,as.numeric)
  cnt <- cnt + 1
  levada[[cnt]] <- tmp
  print(tail(levada[[cnt]]))
}
