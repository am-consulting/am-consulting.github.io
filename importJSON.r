# http://jbrc.recruitjobs.co.jp/data/opendata/
# http://stackoverflow.com/questions/2617600/importing-data-from-a-json-file-into-r
library(rjson)
jsonURL <-
  "http://jbrc.recruitjobs.co.jp/data/opendata/csv/201703_opendata.json"
jsonData <-
  rjson::fromJSON(paste(iconv(readLines(jsonURL,encoding = 'shift_jis'),
                              from = 'shift_jis',
                              to = 'UTF-8'),
                        collapse = "")
                  )
jsonDataDF <-
  data.frame(matrix(unlist(jsonData), ncol = length(jsonData[[1]]), byrow = T))
colnames(jsonDataDF) <-
  names(jsonData[[1]])
