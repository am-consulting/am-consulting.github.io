# https://www.bls.gov/news.release/empsit.toc.htm
library(rvest)
fun_getTable <- function(){
  tmp0 <-
    data.frame(buf %>% html_table(header = F,fill = T))
  tmp1 <- tmp0
  tmp1[,1] <- gsub('\\([0-9]+\\)','',tmp1[,1])
  tmp1[1,] <- gsub('\\([0-9]+\\)','',tmp1[1,])
  colnames(tmp1) <-
    paste0(tmp1[1,],':',tmp1[2,])
  colnames(tmp1)[1] <- tmp1[1,1]
  tmp1 <- tmp1[-c(1,2),]
  tmp1[tmp1==''] <- NA
  tmp1 <- tmp1[!is.na(tmp1[,1]),]
  tmp1[,-1] <- apply(tmp1[,-1],2,function(x)as.numeric(gsub(',|\\$','',x)))
  sepRaw <- which(is.na(tmp1[,2]))
  for(iii in 1:2){
    tmp2 <- tmp1[sepRaw[iii]:(sepRaw[iii+1]-1),]
    colnames(tmp2)[1] <- paste0(colnames(tmp2)[1],':',tmp2[1,1])
    tmp2 <- tmp2[-1,]
    if(iii==1){table01 <- tmp2}else{table02<-tmp2}
  }
  returnList <-
      list('table01' = table01,
           'table02' = table02)
  return(returnList)
}
################################################
targetURL <-
  'https://www.bls.gov/news.release/jolts.a.htm'
htmlMarkup <-
  read_html(x = targetURL,encoding = 'UTF-8')
buf <-
  htmlMarkup %>% html_nodes(xpath = "//table[@id = 'jolts_tablea']")
tableATitle <- htmlMarkup %>% html_nodes('title') %>% html_text()
bufTable <- fun_getTable()
tableA01 <- bufTable$table01
tableA02 <- bufTable$table02
################################################
for(sss in 1:12){
  targetURL <-
    paste0('https://www.bls.gov/news.release/jolts.t',formatC(sss,width=2,flag="0"),'.htm')
  htmlMarkup <-
    read_html(x = targetURL,encoding = 'UTF-8')
  buf <-
    htmlMarkup %>% html_nodes(xpath = paste0("//table[@id = 'jolts_table",sss,"']"))
  assign(paste0('table',formatC(sss,width=2,flag="0"),'Title'),
         htmlMarkup %>% html_nodes('title') %>% html_text())
  bufTable <- fun_getTable()
  assign(paste0('table',formatC(sss,width=2,flag="0"),'01'),bufTable$table01)
  assign(paste0('table',formatC(sss,width=2,flag="0"),'02'),bufTable$table02)
}
