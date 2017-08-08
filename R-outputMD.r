# https://github.com/benweet/stackedit/issues/137
fun_outputMD <-
  function(tags = '貸出約定平均金利,日本銀行',
           title = title,
           objDF = summaryByName,
           summaryDF = cbind(c('A'),c(1)),
           dateFormat = '%Y-%m-%d',
           dateCol = 1,
           objCol = 2,
           htmlName = htmlName,
           tableTitle = tableTitle,
           dataTitle = '',
           image1 = 0,
           image2 = 0,
           image3 = 0,
           tableName = '内閣総理大臣毎の基本統計量'){
    username <-
      Sys.info()['user']
    pathToFile <-
      paste0('C:/Users/', username,'/Desktop/pathToCSV/')
    setwd(pathToFile)
    fileName <-
      'defaultPath.csv'
  buf <-
    read.csv(file = fileName,
             header = F,
             skip = 0,
             stringsAsFactor = F,
             check.names = F,
             fileEncoding = 'utf-8',quote = "\"")
  pathOutputTOcsv <-
    paste0("C:/Users/", username, buf[2,1],'md/')
  setwd(pathOutputTOcsv)
  getwd()
  mdFile <-
    paste0(format(Sys.Date(),'%Y%m%d'),'-olive.md')
  # md作成パート
  txt <- paste0('
---
tags : [',tags,']
title : ',title,'
published : true
---\n\n')
  write.table(x = txt,file = mdFile,append = F,
              fileEncoding = 'utf8',col.names = F,row.names = F,quote = F)
  # summary part
  if(nrow(summaryDF)!=1){
  obj <- summaryDF[,c(dateCol,objCol)]
  dateRange <-
    paste0(paste0(format(range(obj[,1]),dateFormat),collapse = 'から'),'における')
  indicatorName <- colnames(obj)[2]
  txt <- paste0('#### Summary\n\n')
  for(iii in 1:6){
    statName <- switch(iii,'最小値','第1四分位数','中央値','平均値','第3四分位数','最大値')
    txt <-
      paste0(txt,
             paste0('- ',indicatorName,'の',dateRange,statName,'は',summary(obj[,2])[iii],'\n'))
  }
  meanResult <-
    fun_meanS(objDF = obj,dateCol = 1,objCol = 2,dateFormat = dateFormat)
  meanResult <- meanResult[-grep('^平均値|^中央値',meanResult[,1]),]
  for(iii in 1:nrow(meanResult)){
    txt <-
      paste0(txt,
             paste0('- ',indicatorName,'の',dateRange,meanResult[iii,1],'は',meanResult[iii,2],'\n'))
  }
  summaryResult <- fun_summaryByName(obj = obj,objColumn = 2,dateFormat = dateFormat)
  maxResult <- summaryResult[which.max(summaryResult$Mean),]
  minResult <- summaryResult[which.min(summaryResult$Mean),]
  txt <-
    paste0(txt,
           paste0('- ',indicatorName,'の平均値が最も高い政権は',maxResult[1,1],'政権の',
                  maxResult[1,grep('mean',colnames(maxResult),ignore.case = T)],'\n'))
  txt <-
    paste0(txt,
           paste0('- ',indicatorName,'の平均値が最も低い政権は',minResult[1,1],'政権の',
                  minResult[1,grep('mean',colnames(minResult),ignore.case = T)],'\n'))
  write.table(x = txt,file = mdFile,append = T,
              fileEncoding = 'utf8',col.names = F,row.names = F,quote = F)
  }
  # summary part
  if(image1!=0){
    txt <- paste0('<a href="http://knowledgevault.saecanet.com/charts/chartImages/',
                  htmlName,
                  '1.png"><img border="0" src="http://knowledgevault.saecanet.com/charts/chartImages/',
                  htmlName,
                  '1.png" width="100%" /></a>\n\n')
    write.table(x = txt,file = mdFile,append = T,
                fileEncoding = 'utf8',col.names = F,row.names = F,quote = F)
  }
  if(image2!=0){
    txt <- paste0('<a href="http://knowledgevault.saecanet.com/charts/chartImages/',
                  htmlName,
                  '2.png"><img border="0" src="http://knowledgevault.saecanet.com/charts/chartImages/',
                  htmlName,
                  '2.png" width="100%" /></a>\n\n')
    write.table(x = txt,file = mdFile,append = T,
                fileEncoding = 'utf8',col.names = F,row.names = F,quote = F)
  }
  if(image3!=0){
    txt <- paste0('<a href="http://knowledgevault.saecanet.com/charts/chartImages/',
                  htmlName,
                  '3.png"><img border="0" src="http://knowledgevault.saecanet.com/charts/chartImages/',
                  htmlName,
                  '3.png" width="100%" /></a>\n\n')
    write.table(x = txt,file = mdFile,append = T,
                fileEncoding = 'utf8',col.names = F,row.names = F,quote = F)
  }
  txt <- paste0('***','\n\n')
  write.table(x = txt,file = mdFile,append = T,
              fileEncoding = 'utf8',col.names = F,row.names = F,quote = F)
  txt <- paste0('#### ',tableName,'','\n\n')
  write.table(x = txt,file = mdFile,append = T,
              fileEncoding = 'utf8',col.names = F,row.names = F,quote = F)
  txt <- paste0('- ',tableTitle,'','\n\n')
  write.table(x = txt,file = mdFile,append = T,
              fileEncoding = 'utf8',col.names = F,row.names = F,quote = F)
  txt <- paste0(knitr::kable(x = objDF,
                             row.names = F,
                             format = 'html',
                             # align = 'r',
                             table.attr = "id = 'amcc' width = '100%'",
                             format.args = list(big.mark = ',',drop0trailing = T),
                             escape = F),'\n')
  write.table(x = txt,file = mdFile,append = T,
              fileEncoding = 'utf8',col.names = F,row.names = F,quote = F)
  txt <- paste0('## データテーブル･チャート','\n\n')
  write.table(x = txt,file = mdFile,append = T,
              fileEncoding = 'utf8',col.names = F,row.names = F,quote = F)
  txt <- paste0('Link : [データテーブル･チャート](http://knowledgevault.saecanet.com/charts/am-consulting.co.jp-',htmlName,'.html)\n\n')
  write.table(x = txt,file = mdFile,append = T,
              fileEncoding = 'utf8',col.names = F,row.names = F,quote = F)
  txt <- paste0('<iframe src="http://knowledgevault.saecanet.com/charts/am-consulting.co.jp-',
                htmlName,
                '.html" width="100%" height="1200px"></iframe>')
  write.table(x = txt,file = mdFile,append = T,
              fileEncoding = 'utf8',col.names = F,row.names = F,quote = F)
  # md作成パート
  }
