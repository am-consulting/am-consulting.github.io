library(rvest)
library(Nippon)
targetURL <-
  c('http://www.mof.go.jp/budget/fiscal_condition/basic_data/201704/sy2904a.html',
    'http://www.mof.go.jp/budget/fiscal_condition/basic_data/201704/sy2904e.html')
###########################
iii <- 1
htmlMarkup <-
  read_html(x = targetURL[iii],encoding = 'shift_jis')
buf0 <-
  data.frame(htmlMarkup %>%
               html_nodes(xpath = "//div[@id = 'hon-base']") %>%
               html_nodes('table') %>%
               html_table(header = F, fill = T),
             check.names = F,stringsAsFactors = F)
colnames(buf0) <-
  sapply(paste0(buf0[1,],':',buf0[2,]),zen2han)
objCol <-
  which(gsub('(.+):(.*)','\\1',colnames(buf0))==gsub('(.+):(.*)','\\2',colnames(buf0)))
colnames(buf0)[objCol] <-
  buf0[1,objCol]
colnames(buf0) <-
  gsub(':$','',colnames(buf0))
colnames(buf0) <-
  gsub('▲|△|△ ',
       '',
       colnames(buf0))
buf1 <- buf0[-c(1,2),]
buf1[,1] <-
  sapply(buf1[,1],zen2han)
buf1[buf1==''] <- NA
buf1[,-1] <-
  apply(buf1[,-1],2,function(x)as.numeric(gsub(',','',gsub('▲|△|△ ',
                                                           '-',
                                                           gsub('\\(|\\)','',x)))))
objRaw <-
  grep('歳入|歳出',buf1[,1])
buf1[objRaw,1] <-
  gsub('\\((.+)\\)','\\1:',buf1[objRaw,1])
buf1[objRaw[1]:(objRaw[2]-1),1] <-
  paste0(buf1[objRaw[1],1],buf1[objRaw[1]:(objRaw[2]-1),1])
buf1[objRaw[2]:nrow(buf1),1] <-
  paste0(buf1[objRaw[2],1],buf1[objRaw[2]:nrow(buf1),1])
buf2 <- buf1[-objRaw,]
objCol <-
  tail(grep(':当初$',colnames(buf2)),1)
colnames(buf2)[objCol] <-
  paste0(colnames(buf2)[objCol],':','対前年度当初伸率')
objCol <-
  head(grep('\\(',colnames(buf2)),1)
colnames(buf2)[objCol] <-
  gsub('\\(.+\\)','',colnames(buf2)[objCol])
objCol <-
  tail(grep('\\(',colnames(buf2)),1)
colnames(buf2)[objCol] <-
  gsub('増減額|\\(|\\)','',colnames(buf2)[objCol])
row.names(buf2) <- NULL
objCol <-
  grep('区分|率',colnames(buf2))
colnames(buf2)[-objCol] <-
  paste0(colnames(buf2)[-objCol],'(億円)')
objCol <-
  grep('率',colnames(buf2))
colnames(buf2)[objCol] <-
  paste0(colnames(buf2)[objCol],'(%)')
yosanSouhyou <- buf2
remove('buf0','buf1','buf2','objRaw','objCol','htmlMarkup')
###########################
iii <- 2
htmlMarkup <-
  read_html(x = targetURL[iii],encoding = 'shift_jis')
buf0 <-
  htmlMarkup %>% html_nodes(xpath = "//div[@id = 'hon-base']") %>% html_nodes('table')
buf0 <-
  data.frame(buf0[2] %>%
               html_table(header = F, fill = T),
             check.names = F,stringsAsFactors = F)
buf1 <- buf0[-c(1,2),]
buf1[,1] <- sapply(buf1[,1],zen2han)
buf1[,-1] <-
  apply(buf1[,-1],2,function(x)as.numeric(gsub(',','',gsub('▲|△|△ ',
                                                           '-',
                                                           gsub('\\(|\\)','',x)))))
objRaw <- grep('元',buf1[,1])
buf1[objRaw,1] <- 1
buf1[1:(objRaw-1),1] <-
  as.numeric(buf1[1:(objRaw-1),1]) + 1925
buf1[objRaw:nrow(buf1),1] <-
  as.numeric(buf1[objRaw:nrow(buf1),1]) + 1988
colnames(buf1) <-
  c('年度',
    '一般会計歳出(伸率,%)',
    'PB対象経費:全体(伸率,%)',
    'PB対象経費:地方交付税等(伸率,%)',
    '公債発行額(億円)',
    '建設公債(億円)',
    '特例公債(億円)',
    '公債依存度:当初(%)',
    '公債依存度:実績(%)',
    '税収比率(%)',
    '公債残高(億円)',
    '公債残高:GDP(%)',
    '国債費(億円)',
    '国債費:一般会計(%)')
row.names(buf1) <- NULL
ippanKaikeiYosan <- buf1
remove('buf0','buf1','objRaw','htmlMarkup')
