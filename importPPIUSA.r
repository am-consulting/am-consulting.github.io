# https://www.bls.gov/news.release/empsit.toc.htm
library(rvest)
targetURL <-
  'https://www.bls.gov/news.release/ppi.htm'
htmlMarkup <-
  read_html(x = targetURL,encoding = 'UTF-8')
tableS <-
  htmlMarkup %>% html_nodes('table')
objTableS <-
  tableS[grep('table[0-9]+',tableS)]
captionS <-
  objTableS %>% html_nodes('caption') %>% html_text()
captionS <-
  gsub('\\([0-9]+\\)|\n','',captionS)
tableList <- objTableS %>% html_table(fill = T,header = F)
PPIUSA <- list()
for(iii in seq(length(tableList))){
  buf0 <- data.frame(tableList[[iii]],stringsAsFactors = F)
  colnames(buf0) <- paste0(buf0[1,],':',buf0[2,])
  objCol <-
    gsub('(.+):(.+)','\\1',colnames(buf0))==gsub('(.+):(.+)','\\2',colnames(buf0))
  colnames(buf0)[objCol] <- buf0[1,objCol]
  colnames(buf0) <- gsub('::',':',colnames(buf0))
  colnames(buf0) <- gsub('\\([0-9]+\\)','',colnames(buf0))
  buf1 <- buf0[-c(1,2),]
  if(iii==4|iii==5|iii==6){charaCol <- c(1,2,3)}else{charaCol <- c(1,2)}
  buf1[,-charaCol] <- apply(buf1[,-charaCol],2,function(x)as.numeric(gsub(',','',x)))
  buf2 <- buf1[!is.na(buf1[,ncol(buf1)]),]
  row.names(buf2) <- NULL
  buf2[is.na(buf2)] <- ''
  buf2[,1] <- gsub('\\([0-9]+\\)','',buf2[,1])
  print(head(buf2,1))
  PPIUSA[[iii]] <- buf2
}
remove('buf0','buf1','buf2','charaCol')
