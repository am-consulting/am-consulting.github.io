# https://www.bls.gov/news.release/empsit.toc.htm
library(rvest)
targetURL <-
  'https://www.bls.gov/news.release/laus.htm'
htmlMarkup <-
  read_html(x = targetURL)
objTableS <-
  htmlMarkup %>% html_nodes('table')
captionS <-
  objTableS %>% html_nodes('caption') %>% html_text()
captionS <-
  gsub('\n|\\([0-9]+\\)','',captionS)
captionS <-
  gsub('([a-z])table','\\1 Table',captionS,ignore.case = T)
captionS <-
  gsub('DATANOT','DATA NOT',captionS,ignore.case = T)
captionS <-
  gsub('DATASEASONALLY','DATA SEASONALLY',captionS,ignore.case = T)
tableList <-
  objTableS %>% html_table(fill = T,header = F)
StateEmploymentAndUnemployment <- list()
for(iii in seq(length(tableList))){
  buf0 <-
    data.frame(tableList[[iii]],stringsAsFactors = F)
  buf1 <- buf0
  if(iii==1|iii==6|iii==7|iii==8|iii==9){
    buf1[3,buf1[2,]==buf1[3,]] <- NA
    buf1[2,buf1[1,]==buf1[2,]] <- NA
    colnames(buf1) <- paste0(buf1[1,],':',buf1[2,],':',buf1[3,])
    colnames(buf1) <- gsub(':na','',colnames(buf1),ignore.case = T)
    buf2 <- buf1[-c(1:3),]
  }
  if(iii==3|iii==4|iii==5){
    buf1[2,buf1[1,]==buf1[2,]] <- NA
    colnames(buf1) <- paste0(buf1[1,],':',buf1[2,])
    colnames(buf1) <- gsub(':na','',colnames(buf1),ignore.case = T)
    buf2 <- buf1[-c(1:2),]
  }
  if(iii==2){
    buf1[4,buf1[3,]==buf1[4,]] <- NA
    buf1[3,buf1[2,]==buf1[3,]] <- NA
    buf1[2,buf1[1,]==buf1[2,]] <- NA
    colnames(buf1) <- paste0(buf1[1,],':',buf1[2,],':',buf1[3,],':',buf1[4,])
    colnames(buf1) <- gsub(':na','',colnames(buf1),ignore.case = T)
    buf2 <- buf1[-c(1:4),]
  }
  colnames(buf2) <-
    gsub('\\([0-9]+\\)','',colnames(buf2))
  colnames(buf2) <-
    gsub(':([0-9]{4})','.\\1',colnames(buf2))
  buf2[,-1] <-
    apply(buf2[,-1],2,function(x)as.numeric(gsub(',','',x)))
  buf3 <- buf2[!is.na(buf2[,2]),]
  buf3[,1] <-
    gsub('\\([0-9]+\\)','',buf3[,1])
  print(buf3)
  StateEmploymentAndUnemployment[[iii]] <- buf3
  cat('\n\n#########################\n\n')
}
remove('buf0','buf1','buf2','buf3')
