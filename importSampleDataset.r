csvURL <- 'https://raw.githubusercontent.com/am-consulting/am-consulting.github.io/master/csv/%E4%B8%8D%E5%8B%95%E7%94%A3%E5%8F%96%E5%BC%95%E4%BE%A1%E6%A0%BC%E6%83%85%E5%A0%B1_%E6%9D%B1%E4%BA%AC%E9%83%BD_2016%E5%B9%B4%E5%BA%A6%E7%AC%AC1%E5%9B%9B%E5%8D%8A%E6%9C%9F(%E3%83%87%E3%83%BC%E3%82%BF%E5%87%BA%E6%89%80-%E5%9B%BD%E5%9C%9F%E4%BA%A4%E9%80%9A%E7%9C%81%E5%9C%9F%E5%9C%B0%E7%B7%8F%E5%90%88%E6%83%85%E5%A0%B1%E3%82%B7%E3%82%B9%E3%83%86%E3%83%A0).csv'
sampleDataset <-
  read.csv(
    csvURL,
    check.names = F,
    stringsAsFactors = T,
    fileEncoding = 'utf-8'
  )