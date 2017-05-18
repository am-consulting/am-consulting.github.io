library(rvest);library(XLConnect)
username <-
  Sys.info()['user']
pathOutput <-
  paste0("C:/Users/", username, "/Desktop/R_Data_Write/")
setwd(pathOutput)
targetURL <-
  'http://www.policyuncertainty.com/index.html'
htmlMarkup <-
  read_html(x = targetURL,encoding = 'UTF-8')
sideBarS <-
  htmlMarkup %>% html_nodes(xpath = "//div[@class = 'sidebar_item']")
epuTitle <- sideBarS[c(1,2)] %>% html_nodes('a') %>% html_text()
epuURL <- sideBarS[c(1,2)] %>% html_nodes('a') %>% html_attr('href')
baseURL <- 'http://www.policyuncertainty.com/'
EconomicPolicyUncertaintyIndex <- list()
EPUList <- vector()
cnt <- 1
for(iii in seq(length(epuURL))){
  if(length(grep('monthly',epuURL[iii],ignore.case = T))!=0){
    htmlMarkup <-
      read_html(x = paste0(baseURL,epuURL[iii]))#,encoding = 'UTF-8')
    contentData <-
      htmlMarkup %>% html_nodes(xpath = "//div[@class = 'content_data_item']")
    hrefS <-
      contentData %>% html_nodes('a') %>% html_attr('href')
    xlsxFile <-
      hrefS[grep('.xlsx',hrefS)]
    fileName <-
      gsub('.+/([^/]+)','\\1',xlsxFile)
    download.file(paste0(baseURL,xlsxFile),fileName[1],mode = 'wb')
    buf0 <-
      readWorksheetFromFile(paste0(pathOutput,fileName[1]), sheet = 1, check.names = F, header = T)
    # 列名に最初からdateがあるパターン
    objCol <- grep('date',colnames(buf0),ignore.case = T)
    if(length(objCol)!=0){
      buf0[,objCol] <-  as.Date(buf0[,objCol])
      buf1 <- buf0[!is.na(buf0[,1]),]
      buf1[,-objCol] <- apply(buf1[,-objCol,drop=F],2,as.numeric)
      dataSet <- buf1
      pattern <- '列名に最初からdateがあるパターン'
    }
    # 列名が2行に分かれているパターン
    # 始めに列名を整理する
    # Global_Policy_Uncertainty_Data.xlsx
    keyWord <- 'year'
    objRow1 <- which(apply(buf0,1,function(x)(length(grep(keyWord,x,ignore.case = T))))!=0)
    objCol1 <- which(apply(buf0,2,function(x)(length(grep(keyWord,x,ignore.case = T))))!=0)
    if(length(objRow1)!=0){colnames(buf0)[objCol1]<- buf0[objRow1,objCol1]}
    keyWord <- 'month'
    objRow2 <- which(apply(buf0,1,function(x)(length(grep(keyWord,x,ignore.case = T))))!=0)
    objCol2 <- which(apply(buf0,2,function(x)(length(grep(keyWord,x,ignore.case = T))))!=0)
    if(length(objRow2)!=0){colnames(buf0)[objCol2]<- buf0[objRow2,objCol2]}
    # 列名にyear,monthがあるパターン
    if(length(grep('year',colnames(buf0),ignore.case = T))!=0){
      buf1 <- buf0[apply(buf0,1,function(x)sum(is.na(x))) < (ncol(buf0)-2),]
      colCheck <-
        c(grep('^col[0-9]+$',colnames(buf1),ignore.case = T),which(is.na(colnames(buf1))))
      if(length(colCheck)!=0){buf1 <- buf1[,-colCheck]}
      yearCol <- grep('year',colnames(buf1),ignore.case = T)
      monthCol <- grep('month',colnames(buf1),ignore.case = T)
      Date <-
        as.Date(paste0(buf1[,yearCol],'-',buf1[,monthCol],'-1'))
      buf2 <-
        data.frame(Date,apply(buf1[,-c(yearCol,monthCol),drop=F],2,as.numeric),
                   stringsAsFactors = F,check.names = F,row.names = NULL)
      dataSet <- buf2
      pattern <-'列名にyear,monthがあるパターン'
    }
    # 列名ではなくセルにdateがあるパターン
    keyWord <- 'date'
    objRow1 <- which(apply(buf0,1,function(x)(length(grep(keyWord,x,ignore.case = T))))!=0)
    objCol1 <- which(apply(buf0,2,function(x)(length(grep(keyWord,x,ignore.case = T))))!=0)
    if(length(objRow1)!=0){
      colnames(buf0)<- buf0[objRow1,]
      buf1 <- buf0[-c(1:objRow1),]
      buf1[,1] <-
        as.Date(gsub('([0-9]+)m([0-9]+)','\\1-\\2-1',gsub('\\s','',buf1[,objCol1])))
      buf2 <- buf1[!is.na(buf1[,1]),]
      dataSet <- buf2
      pattern <- '列名ではなくセルにdateがあるパターン'
    }
    # date列はあるが列名がdateではないパターン
    if(length(grep('date',colnames(buf0),ignore.case = T))==0){
      if(!is.na(as.numeric(substring(buf0[1,1],6,6)))){
        if(class(as.Date(buf0[1,1]))=='Date'){
          buf0[,1] <- as.Date(buf0[,1])
          colnames(buf0)[1] <- 'Date'
          buf1 <- buf0[!is.na(buf0[,1]),]
          dataSet <- buf1
          pattern <- 'date列はあるが列名がdateではないパターン'
        }
      }
    }
    colnames(dataSet)[-1] <-
      paste0(toupper(gsub('([^_]+)_.+','\\1',epuURL[iii])),':',gsub('\\*','',colnames(dataSet)[-1]))
    row.names(dataSet) <- NULL
    EconomicPolicyUncertaintyIndex[[cnt]] <- dataSet
    EPUList[cnt] <- paste0(iii,':',fileName[1])
    print(EPUList[cnt])
    print(pattern)
    print(tail(EconomicPolicyUncertaintyIndex[[cnt]],1))
    cnt <- cnt + 1
  }
}
