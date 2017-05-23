# https://github.com/benweet/stackedit/issues/137
fun_outputMD <-
  function(tags = '貸出約定平均金利,日本銀行',
           objDF = summaryByName,
           htmlName = htmlName,
           tableTitle = tableTitle,
           dataTitle = dataTitle,
           image = 0,
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
  cat('',file = mdFile,append = F)
  cat(paste0('
---
tags : [',tags,']
published : true
---\n\n'),file = mdFile,append = T)
  cat(paste0('# ',dataTitle,'\n\n'),
      file = mdFile,append = T)
  if(image1!=0){
    cat(paste0('<a href="http://knowledgevault.saecanet.com/charts/chartImages/',
               htmlName,
               '1.png"><img border="0" src="http://knowledgevault.saecanet.com/charts/chartImages/',
               htmlName,
               '1.png" width="100%" /></a>\n\n'),
        file = mdFile,append = T)
  }
  if(image2!=0){
    cat(paste0('<a href="http://knowledgevault.saecanet.com/charts/chartImages/',
               htmlName,
               '2.png"><img border="0" src="http://knowledgevault.saecanet.com/charts/chartImages/',
               htmlName,
               '2.png" width="100%" /></a>\n\n'),
        file = mdFile,append = T)
  }
  # cat('\n\n<style>table#amcc td {text-align:right;} </style>\n\n',
  #     file = mdFile,append = T)
  cat(paste0('***','\n\n'),
      file = mdFile,append = T)
  cat(paste0('#### ',tableName,'','\n\n'),
      file = mdFile,append = T)
  cat(paste0('- ',tableTitle,'','\n\n'),
      file = mdFile,append = T)
  cat(paste0(knitr::kable(x = objDF,
                          row.names = F,
                          format = 'html',
                          # align = 'r',
                          table.attr = "id = 'amcc' width = '100%'",
                          format.args = list(big.mark = ',',drop0trailing = T),
                          escape = F),'\n'),
      file = mdFile,append = T)
  cat(paste0('\n\n***','\n\n'),
      file = mdFile,append = T)
  cat(paste0('## データテーブル･チャート','\n\n'),
      file = mdFile,append = T)
  cat(paste0('Link : [データテーブル･チャート](http://knowledgevault.saecanet.com/charts/am-consulting.co.jp-',
             htmlName,
             '.html)\n\n'),
      file = mdFile,append = T)
  cat(paste0('<iframe src="http://knowledgevault.saecanet.com/charts/am-consulting.co.jp-',
             htmlName,
             '.html" width="100%" height="800px"></iframe>'),
      file = mdFile,append = T)
  # md作成パート
  }
