# https://www.bls.gov/news.release/empsit.toc.htm
library(rvest)
targetURL <-
  'https://www.bls.gov/news.release/realer.htm'
htmlMarkup <-
  read_html(x = targetURL)
objTableS <-
  htmlMarkup %>% html_nodes('table')
captionS <-
  objTableS %>% html_nodes('caption') %>% html_text()
captionS <-
  gsub('\n|\\([0-9]+\\)','',captionS)
tableList <-
  objTableS %>% html_table(fill = T,header = F)
RealEarnings <- list()
for(iii in seq(length(tableList))){
  buf0 <-
    data.frame(tableList[[iii]],stringsAsFactors = F)
  colnames(buf0) <- buf0[1,]
  colnames(buf0)[1] <- 'Subject'
  buf1 <- buf0[-1,]
  buf2 <-
    buf1[buf1[,1]!='',]
  buf3 <-
    buf2[-grep('[a-z]',substring(buf2[,2],nchar(buf2[,2])),ignore.case = T),]
  row.names(buf3) <- NULL
  buf3[,1] <-
    gsub('\\([0-9]+\\)','',buf3[,1])
  tmp <- NA
  for(rrr in seq(nrow(buf3))){
    if(buf3[rrr,2]==''){tmp <- buf3[rrr,1]}
    buf3[rrr,1] <- paste0(tmp,':',buf3[rrr,1])
  }
  buf3[,1] <-
    gsub('na:','',buf3[,1],ignore.case = T)
  buf4 <-
    buf3[buf3[,2]!='',]
  objRaw <-
    grep('\\$',buf4[,2])
  buf4[objRaw,1] <-
    paste0(buf4[objRaw,1],'(Unit:$)')
  buf4[,-1] <-
    apply(buf4[,-1],2,function(x)as.numeric(gsub('\\$','',x)))
  print(buf4)
  RealEarnings[[iii]] <- buf4
}
remove('buf0','buf1','buf2','buf3','buf4')
