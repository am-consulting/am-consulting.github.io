# http://tochi.mlit.go.jp/torihiki/torihiki-kensu
# http://tochi.mlit.go.jp/plan/kennsuu/H27/2_1.90000.H27.files/sheet001.htm
# http://tochi.mlit.go.jp/plan/kennsuu/H26/2_1.90000.H26.files/sheet001.htm
# http://tochi.mlit.go.jp/plan/kennsuu/H25/2_1.90000.H25.files/sheet001.htm
# http://tochi.mlit.go.jp/post_term/data
fun_landDealNumber <- function(yy = 28){
library(rvest);library(Nippon)
htmlMarkup <-
  read_html(x = paste0('http://tochi.mlit.go.jp/plan/kennsuu/H',yy,'/2_1.90000.H',yy,'.files/sheet001.htm'),
            encoding = 'shift_jis')
trTex <-
  htmlMarkup %>% html_nodes('table') %>% html_nodes('tr')
for(rrr in seq(trTex)){
  tdTex <-
    trTex[rrr] %>% html_nodes('td') %>% html_text()
  if(rrr == 1){
    tableData <- tdTex
  }else{
    tableData <- rbind(tableData,tdTex)
  }
}
colnames(tableData) <-
  tableData[1,]
tableData <- tableData[-1,]
row.names(tableData) <- NULL
tableData1 <-
  data.frame(tableData[,c(1,2)],
             apply(tableData[,-c(1,2)],2,function(x)as.numeric(gsub('\\s','',x))),
             stringsAsFactors = F,check.names = F,row.names = NULL)
colnames(tableData1) <-
  sapply(colnames(tableData1),zen2han)
tableData1 <-
  tableData1[-which(tableData1[,1]==''),]
tableData1$`合計` <- apply(tableData1[,-c(1,2)],1,function(x)sum(x,na.rm = T))
tableData1$`構成比(%)` <- round(tableData1$`合計`/sum(tableData1$`合計`)*100,2)
assign(paste0('landDealNumber',yy),tableData1,envir = .GlobalEnv)
assign(paste0('landDealNumberTotal',yy),sum(tableData1$`合計`),envir = .GlobalEnv)
}
