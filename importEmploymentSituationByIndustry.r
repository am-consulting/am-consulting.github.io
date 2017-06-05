# https://www.bls.gov/news.release/empsit.toc.htm
library(rvest)
fun_getTable <- function(){
  tmp0 <-
    data.frame(buf %>% html_table(header = F,fill = T))
  tmp1 <- tmp0
  colnames(tmp1) <-
    paste0(tmp1[1,],':',tmp1[2,])
  colnames(tmp1)[1] <- tmp1[1,1]
  tmp1 <- tmp1[-c(1,2),]
  tmp1[tmp1==''] <- NA
  tmp1 <- tmp1[!is.na(tmp1[,1]),]
  tmp1[,-1] <- apply(tmp1[,-1],2,function(x)as.numeric(gsub(',|\\$','',x)))
  tmp1 <- tmp1[apply(tmp1,1,function(x)sum(is.na(x)))!=(ncol(tmp1)-1),]
  tmp1[,1] <- gsub('\\(.+\\)','',tmp1[,1])
  colnames(tmp1) <- gsub('ofunemployedpersons','of unemployed persons',colnames(tmp1))
  colnames(tmp1) <- gsub('Unemploymentrates','Unemployment rates',colnames(tmp1))
  colnames(tmp1) <- gsub(':Change from:',':Change from',colnames(tmp1))
  print(colnames(tmp1))
  return(tmp1)
}
################################################
targetURL <-
  'https://www.bls.gov/news.release/empsit.t14.htm'
htmlMarkup <-
  read_html(x = targetURL,encoding = 'UTF-8')
buf <-
  htmlMarkup %>% html_nodes(xpath = "//table[@id = 'cps_empsit_a11']")
tableA14Title <- htmlMarkup %>% html_nodes('title') %>% html_text()
tableA14 <- fun_getTable()
################################################
targetURL <-
  'https://www.bls.gov/news.release/empsit.t17.htm'
htmlMarkup <-
  read_html(x = targetURL,encoding = 'UTF-8')
buf <-
  htmlMarkup %>% html_nodes(xpath = "//table[@id = 'ces_table1']")
tableB1Title <- htmlMarkup %>% html_nodes('title') %>% html_text()
tableB1 <- fun_getTable()
################################################
fun_getTableForB2 <- function(){
  colnames(tmp1) <- tmp1[1,]
  sheetTitle <- tmp1[2,1]
  tmp1 <- tmp1[-c(1,2),]
  tmp1[tmp1==''] <- NA
  tmp1 <- tmp1[!is.na(tmp1[,1]),]
  tmp1[,-1] <- apply(tmp1[,-1],2,function(x)as.numeric(gsub(',|\\$','',x)))
  tmp1 <- tmp1[apply(tmp1,1,function(x)sum(is.na(x)))!=(ncol(tmp1)-1),]
  tmp1[,1] <- gsub('\\(.+\\)','',tmp1[,1])
  colnames(tmp1)[1] <- paste0(colnames(tmp1)[1],':',sheetTitle)
  return(tmp1)
}
targetURL <-
  'https://www.bls.gov/news.release/empsit.t18.htm'
htmlMarkup <-
  read_html(x = targetURL,encoding = 'UTF-8')
buf <-
  htmlMarkup %>% html_nodes(xpath = "//table[@id = 'ces_table2']")
tableB2Title <- htmlMarkup %>% html_nodes('title') %>% html_text()
tmp0 <-
  data.frame(buf %>% html_table(header = F,fill = T))
objCol <- grep('AVERAGE OVERTIME HOURS',tmp0[,1],ignore.case = T)
tmp1 <- tmp0[1:(objCol-1),]
tableB2weekly <- fun_getTableForB2()
tmp1 <- tmp0[c(1,objCol:nrow(tmp0)),]
tableB2overtime <- fun_getTableForB2()
################################################
targetURL <-
  'https://www.bls.gov/news.release/empsit.t19.htm'
htmlMarkup <-
  read_html(x = targetURL,encoding = 'UTF-8')
buf <-
  htmlMarkup %>% html_nodes(xpath = "//table[@id = 'ces_table3']")
tableB3Title <- htmlMarkup %>% html_nodes('title') %>% html_text()
tableB3 <- fun_getTable()
remove('tmp0','tmp1','buf')
