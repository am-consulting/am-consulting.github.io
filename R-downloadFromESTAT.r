# 「他の年月の統計表一覧」ページのtclassIDを引数とする。
fun_downloadFromESTAT <- function(tclassID = '000001047452',targetFile = 1){
  library(rvest)
  username <- Sys.info()['user']
  pathOutput <- paste0("C:/Users/", username, "/Desktop/R_Data_Write/")
  setwd(pathOutput)
  pageURL <-
    paste0('http://www.e-stat.go.jp/SG1/estat/GL08020102.do?_toGL08020102_&tclassID=',
           tclassID,
           '&cycleCode=1&requestSender=estat')
  htmlMarkup <-
    read_html(x = pageURL,
              encoding = 'utf8')
  linkList <-
    htmlMarkup %>% html_nodes(xpath = "//table[@class = 'noborder']") %>% html_nodes('a') %>% html_attr('href')
  listIDs <-
    gsub('.+listid=([0-9]+)&.+','\\1',linkList,ignore.case = T)
  targetURL <-
    paste0('http://www.e-stat.go.jp/SG1/estat/',linkList[which(max(listIDs)==listIDs)])
  htmlMarkup <-
    read_html(x = targetURL,
              encoding = 'utf8')
  linkList <-
    htmlMarkup %>% html_nodes(xpath = "//table[@class = 'black']") %>% html_nodes('a') %>% html_attr('href')
  fileList <-
    gsub('.+(gl[0-9]+).+fileid=([0-9]+).+','\\1*\\2',linkList[grep('xlsDownload',linkList)],ignore.case = T)
  buf1 <- gsub('([^*]+)\\*.+','\\1',fileList[targetFile])
  buf2 <- gsub('[^*]+\\*(.+)','\\1',fileList[targetFile])
  fileLink <-
    paste0('http://www.e-stat.go.jp/SG1/estat/',buf1,'.do?_xlsDownload_&fileId=',buf2,'&releaseCount=1')
  download.file(url = fileLink,
                destfile = paste0(buf2,'.xls'),
                mode = 'wb')
  assign('fileNameFromESTAT',paste0(buf2,'.xls'),envir = .GlobalEnv)
  # fileNameとするとR-ListOfPresidents.rのfileNameと競合する(knitでhtmlを出力する際のみ)。
}
