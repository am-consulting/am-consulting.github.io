library(rvest);library(Nippon)
htmlMarkup <-
  read_html(x = 'http://www.moj.go.jp/psia/terrorism/index.html',
            encoding = 'Shift_JIS')
divMarkup <-
  htmlMarkup %>% html_nodes(xpath = "//div[@class = 'leftBox']")
dateMarkup <-
  divMarkup %>% html_nodes(xpath = "//div[@class = 'date']") %>% html_text()
Date <-
  as.Date(gsub('(.+)\\(.+\\)','\\1',dateMarkup))
areaMarkup <-
  divMarkup %>% html_nodes(xpath = "//div[@class = 'area']") %>% html_text()
Area <-
  sapply(areaMarkup,zen2han)
countryMarkup <-
  divMarkup %>% html_nodes('ul')
Country0 <-
  sapply(countryMarkup,function(x)x %>% html_nodes('li') %>% html_text())
Country <-
  sapply(Country0,function(x)paste0(x,collapse = ' , '))
worldTerrorism <-
  data.frame(Date,Area,Country,check.names = F,stringsAsFactors = F,row.names = NULL)
CountryName <-
  unique(unlist(Country0))
incidenceTable <-
  cbind(sapply(CountryName,function(x)length(grep(x,Country0))))
Region <- rownames(incidenceTable)
incidenceTable <-
  data.frame(Region,
             'Number of occurrences' = incidenceTable,
             check.names = F,stringsAsFactors = F,row.names = NULL)
incidenceTable <-
  incidenceTable[order(incidenceTable[,2],decreasing = T),]
colnames(incidenceTable)[2] <-
  paste0(colnames(incidenceTable)[2],'\n',paste0(range(worldTerrorism[,1]),collapse = '~'))
worldTerrorism[,2] <-
  sapply(worldTerrorism[,2],zen2han)
worldTerrorism[,3] <-
  sapply(worldTerrorism[,3],zen2han)
