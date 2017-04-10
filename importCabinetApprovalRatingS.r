library(rvest);library(Nippon);library(dplyr)
cabinetApprovalRatingS <- politicalPartyApprovalRatingsS <- data.frame()
for(yyyy in 1998:2017){
  if(2016 <= yyyy){
    htmlMarkup0 <-
      read_html(x = paste0('https://www.nhk.or.jp/bunken/research/yoron/political/',yyyy,'.html'),
                encoding = 'utf-8')
    cabinet <-
      zen2han(htmlMarkup0 %>% html_nodes(xpath = '//section[@id = \'naikaku\']//caption') %>% html_text())
    cabinet <-
      gsub('.*:(.*)\\(%\\)','\\1',cabinet)
  }else{
    htmlMarkup0 <-
      read_html(x = paste0('https://www.nhk.or.jp/bunken/yoron/political/',yyyy,'.html'),
                encoding = 'utf-8')
  }
  tableList <-
    htmlMarkup0 %>% html_nodes(xpath = '//table') %>% html_table()
  if(yyyy == 2017){
    tableList[[1]] <-
      tableList[[1]][,apply(tableList[[1]],2,function(x)sum(is.na(x)))!=nrow(tableList[[1]])]
    tableList[[2]] <-
      tableList[[2]][,apply(tableList[[2]],2,function(x)sum(is.na(x)))!=nrow(tableList[[2]])]
  }
  for(iii in 1:2){
    buf0 <- tableList[[iii]]
    if(2016 == yyyy){
      buf0 <- rbind(colnames(buf0),buf0)
      if(iii == 1){
        buf0[nrow(buf0)+1,] <- rep(cabinet,ncol(buf0))
        buf0[nrow(buf0),1] <- colnames(cabinetApprovalRatingS)[4]
      }
    }
    if(2017 == yyyy){
      if(iii == 1){
        buf0[nrow(buf0)+1,] <- rep(cabinet,ncol(buf0))
        buf0[nrow(buf0),1] <- colnames(cabinetApprovalRatingS)[4]
      }
    }
    buf1 <- t(buf0)
    colnames(buf1) <- buf1[1,]
    buf2 <- buf1[-1,]
    buf2[,1] <-
      paste0(yyyy,'-', gsub('([0-9]+)月.*','\\1', buf2[,1],perl = T),'-1')
    colnames(buf2) <-
      sapply(gsub('\\s','',colnames(buf2)),zen2han)
    tmpData <-
      data.frame(Date = as.Date(buf2[,1]),buf2[,-1],check.names = F,stringsAsFactors = F,row.names = NULL)
    tmpData <-
      tmpData[apply(tmpData,1,function(x)sum(is.na(x))) != (ncol(tmpData)-1),]
    if(iii == 1){
      cabinetApprovalRating <-  tmpData
    }else{
      politicalPartyApprovalRatings <- tmpData
    }
  }
  politicalPartyApprovalRatingsS <-
    bind_rows(politicalPartyApprovalRatingsS,politicalPartyApprovalRatings)
  endDate <-
    tail(politicalPartyApprovalRatingsS[,1],1)
  cabinetApprovalRatingS <-
    bind_rows(cabinetApprovalRatingS,cabinetApprovalRating)
  cabinetApprovalRatingS <-
    subset(cabinetApprovalRatingS,cabinetApprovalRatingS[,1]<=as.Date(endDate))
}
