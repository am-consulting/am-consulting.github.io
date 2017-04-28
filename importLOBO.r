# http://www.jcci.or.jp/
# http://www.jcci.or.jp/lobo/lobo.html
# －THE QUICK SURVEY SYSTEM OF LOCAL BUSINESS OUTLOOK－
library(XLConnect);library(Nippon);library(lubridate);library(rvest)
username <- Sys.info()['user']
pathOutput <- paste0("C:/Users/", username, "/Desktop/R_Data_Write/")
setwd(pathOutput)
# fileName <- 'lobodi.xls'
# download.file(paste0('http://www.jcci.or.jp/lobo/', fileName),
#               fileName, mode = 'wb')
htmlMarkup <-
  read_html(x = 'https://cci-lobo.jcci.or.jp/',
            encoding = 'utf8')
xlsLink <-
  htmlMarkup %>% html_nodes(xpath = "//div[@class = 'partsBtn']") %>% html_nodes('a') %>% html_attr('href')
fileName <-
  gsub('.+/(.+.xls)','\\1',xlsLink)
download.file(paste0('https://cci-lobo.jcci.or.jp', xlsLink),
              fileName, mode = 'wb')
buf0 <-
  readWorksheetFromFile(paste0(pathOutput, fileName), sheet = 1, check.names = F, header = F)
tmp <- NA
for(ccc in 1:ncol(buf0)){
  if(!is.na(buf0[2,ccc])){tmp <- buf0[2,ccc]}
  buf0[2,ccc] <- tmp
}
colnames(buf0) <- sapply(paste0(buf0[2,],':',buf0[3,]), zen2han)
buf1 <- buf0[-(1:3),]
buf2 <- buf1[,!is.na(buf1[nrow(buf1),])]
yyyy <- as.numeric(substring(buf2[1,1], 1,regexpr('/',buf2[1,1])-1)) + 1900
mm <- as.numeric(substring(buf2[1,1], regexpr('/',buf2[1,1]) + 1))
buf2[,1] <-
  seq(as.Date(paste0(yyyy, '-', mm, '-1')), by = "1 month", length.out = nrow(buf2))
colnames(buf2)[1] <- 'Date'
buf2[,-1] <- apply(buf2[,-1],2,as.numeric)
assign('LOBOCI', buf2, envir = .GlobalEnv)
