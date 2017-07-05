# https://github.com/benweet/stackedit/issues/137
fun_outputMDforTS <-
  function(tags = '',
           title = title,
           objDF = summaryByName,
           htmlName = htmlName,
           tableTitle = tableTitle,
           image1 = 0,
           image2 = 0,
           image3 = 0,
           tableName = '内閣総理大臣毎の基本統計量'){
    username <- Sys.info()['user']
    pathToFile <- paste0('C:/Users/', username,'/Desktop/pathToCSV/')
    setwd(pathToFile)
    fileName <- 'defaultPath.csv'
    buf <-
      read.csv(file = fileName,
               header = F,
               skip = 0,
               stringsAsFactor = F,
               check.names = F,
               fileEncoding = 'utf-8',quote = "\"")
    pathOutputTOcsv <- paste0("C:/Users/", username, buf[2,1],'md/')
    setwd(pathOutputTOcsv)
    mdFile <- paste0(htmlName,'-olive.md')
    # md作成パート
    fun_writeTable <- function(append = T){
      write.table(x = txt,file = mdFile,append = append,
                  fileEncoding = 'utf8',col.names = F,row.names = F,quote = F)
    }
    txt <- paste0('
---
tags : [',tags,']
title : ',title,'
published : true
---\n\n')
    fun_writeTable(append = F)
    if(image1!=0){
      txt <- paste0('<a href="http://knowledgevault.saecanet.com/charts/chartImages/',
                    htmlName,
                    '-1.png"><img border="0" src="http://knowledgevault.saecanet.com/charts/chartImages/',
                    htmlName,
                    '-1.png" width="100%" /></a>\n\n')
      fun_writeTable()
    }
    if(image2!=0){
      txt <- paste0('<a href="http://knowledgevault.saecanet.com/charts/chartImages/',
                    htmlName,
                    '-2.png"><img border="0" src="http://knowledgevault.saecanet.com/charts/chartImages/',
                    htmlName,
                    '-2.png" width="100%" /></a>\n\n')
      fun_writeTable()
    }
    if(image3!=0){
      txt <- paste0('<a href="http://knowledgevault.saecanet.com/charts/chartImages/',
                    htmlName,
                    '-3.png"><img border="0" src="http://knowledgevault.saecanet.com/charts/chartImages/',
                    htmlName,
                    '-3.png" width="100%" /></a>\n\n')
      fun_writeTable()
    }
    txt <- paste0('***','\n\n')
    fun_writeTable()
    txt <- paste0('#### ',tableName,'','\n\n')
    fun_writeTable()
    txt <- paste0('- ',tableTitle,'','\n\n')
    fun_writeTable()
    txt <- paste0(knitr::kable(x = objDF,
                               row.names = F,
                               format = 'html',
                               table.attr = "id = 'amcc' width = '100%'",
                               format.args = list(big.mark = ',',drop0trailing = T),
                               escape = F),'\n')
    fun_writeTable()
    txt <- paste0('\n\n','***','\n\n')
    fun_writeTable()
    txt <- paste0('<div style="text-align:center"><h1><a href="http://knowledgevault.saecanet.com/charts/am-consulting.co.jp-',
                  htmlName,
                  '.html" target="_blank">詳細分析結果</a></h1></div>\n\n')
    fun_writeTable()
    # md作成パート
  }
