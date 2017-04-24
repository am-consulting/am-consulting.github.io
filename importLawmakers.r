library(rvest);library(Nippon)
htmlMarkup <-
  read_html(x = 'http://www.shugiin.go.jp/internet/itdb_annai.nsf/html/statics/shiryo/kaiha_m.htm',
            encoding = 'Shift_JIS')
pageTitle <-
  htmlMarkup %>% html_nodes('title') %>% html_text()
divMarkup <-
  htmlMarkup %>% html_nodes(xpath = "//div[@id = 'MainContentsArea2']")
tableMarkup <-
  divMarkup %>% html_nodes('table')
caption <-
  tableMarkup %>% html_nodes('caption') %>% html_text()
trMarkup <-
  tableMarkup %>% html_nodes('tr')
#####
lawmakerDF <- data.frame()
for(iii in seq(length(trMarkup))){
  chk <-
    length(gregexpr('\n',trMarkup[iii] %>% html_text())[[1]])
  if(chk == 2){
    pattern <-
      '(.+)\n(.+)\n'
  }else if(chk == 3){
    pattern <-
      '(.+)\n(.+)\n(.+)\n'
  }
  lawmakerDF[iii,1] <-
    gsub(pattern,'\\1',trMarkup[iii] %>% html_text())
  if(chk == 2){
    lawmakerDF[iii,2] <- NA
    lawmakerDF[iii,3] <- gsub(pattern,'\\2',trMarkup[iii] %>% html_text())
    lawmakerDF[iii,4] <- NA
  }else if(chk == 3){
    lawmakerDF[iii,2] <- gsub(pattern,'\\2',trMarkup[iii] %>% html_text())
    lawmakerDF[iii,3] <- gsub(pattern,'\\3',trMarkup[iii] %>% html_text())
    hrefURL <- trMarkup[iii] %>% html_nodes('a') %>% html_attr('href')
    if(length(hrefURL)!=0){
      lawmakerDF[iii,4] <- trMarkup[iii] %>% html_nodes('a') %>% html_attr('href')
    }else{
      lawmakerDF[iii,4] <- NA
    }
  }
}
colnames(lawmakerDF) <-
  lawmakerDF[1,]
lawmakerDF <-
  lawmakerDF[-1,]
lawmakerDF[,3] <-
  as.numeric(gsub('([0-9]+).*','\\1',lawmakerDF[,3]))
colnames(lawmakerDF)[4] <- 'URL'
assign('Shugiin',lawmakerDF)

htmlMarkup <-
  read_html(x = 'http://www.sangiin.go.jp/japanese/joho1/kousei/giin/193/giinsu.htm',
            encoding = 'utf-8')
pageTitle <-
  htmlMarkup %>% html_nodes('title') %>% html_text()
tableDF <-
  data.frame(htmlMarkup %>% html_nodes('table') %>% html_table(),check.names = F)
colnames(tableDF) <-
  gsub('var.[0-9]:','',paste0(colnames(tableDF),':',tableDF[1,]),ignore.case = T)
tableDF <- tableDF[-1,]
tableDF[,-1] <-
  apply(tableDF[,-1],2,function(x)as.numeric(gsub('([0-9]+).*','\\1',x)))
URL <-
  htmlMarkup %>% html_nodes('table') %>% html_nodes('tr')
tableDF[grep('href',URL),9] <-
  URL %>% html_nodes('a') %>% html_attr('href')
colnames(tableDF)[9] <- 'URL'
assign('Sangiin',tableDF)
