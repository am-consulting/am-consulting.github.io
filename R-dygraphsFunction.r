library(dygraphs);library(xts)
dyBarChart <- function(dygraph) {
  dyPlotter(dygraph = dygraph,
            name = "BarChart",
            path = system.file("examples/plotters/barchart.js", package = "dygraphs"))
}

dyUnzoom <-function(dygraph) {
  dyPlugin(dygraph = dygraph,
           name = "Unzoom",
           path = system.file("examples/plugins/unzoom.js", package = "dygraphs"))
}

dyCrosshair <- function(dygraph, direction = c("both", "horizontal", "vertical")) {
  dyPlugin(dygraph = dygraph,
           name = "Crosshair",
           path = system.file("examples/plugins/crosshair.js", package = "dygraphs"),
           options = list(direction = match.arg(direction)))
}

dyMultiColumn <- function(dygraph) {
  dyPlotter(dygraph = dygraph,
            name = "MultiColumn",
            path = system.file("examples/plotters/multicolumn.js", package = "dygraphs"))
}

fun_dygraph <-
  function(obj = dataSet, mainTitle = "", legendWidth = 600, hairDirection = 'both', plotNum = 1, barPlot0 = 0, colors = colors){
  xtsData <- xts(obj[,-1], order.by=obj[,1])
  colnames(xtsData) <- colnames(obj)[-1]
  dygraphPlot <-
    dygraph(xtsData, main = mainTitle, group = 'amcc') %>%
    dyLegend(width = legendWidth, show = "follow") %>%
    dyRangeSelector() %>%
    dyUnzoom() %>% dyCrosshair(direction = hairDirection) %>%
    dyOptions(colors = colors)
  if(barPlot0 == 1){dygraphPlot <- dygraphPlot %>% dyBarChart()}
  assign(paste0('dygraphPlot',plotNum), dygraphPlot, envir = .GlobalEnv)
}

fun_consumptionTax <- function(obj = dataSet){
  borderDate <- tail(obj[,1],1)
  assign('ConsumptionTax', paste0(
    'dyShading(from = \'1989-04-01\', to = \'1997-03-31\',color = \'#FFE6E6\') %>%
    dyShading(from = \'1997-04-01\', to = \'2014-03-31\',color = \'#CCEBD6\') %>%
    dyShading(from = \'2014-04-01\', to = \'', borderDate, '\', color = \'#FFE6E6\') %>%
    dyEvent(\'1997-03-31\', \'消費税3%\', labelLoc = \'bottom\') %>%
    dyEvent(\'2014-03-31\', \'消費税5%\', labelLoc = \'bottom\') %>%
    dyEvent(\'', borderDate, '\', \'消費税8%\', labelLoc = \'bottom\')'), envir = .GlobalEnv)
}

fun_primeMinisterOfJapan <- function(obj = dataSet){
primeMinisterOfJapan <- c(
  "1885-12-22",    "Hirobumi Ito(1)",
  "1888-4-30" ,    "Kiyotaka Kuroda",
  "1889-10-25",    "Sanetomi Sanjo",
  "1889-12-24",    "Aritomo Yamagata(1)",
  "1891-5-6"  ,    "Masayoshi Matsukata(1)",
  "1892-8-8"  ,    "Hirobumi Ito(2)",
  "1896-9-18" ,    "Masayoshi Matsukata(2)",
  "1898-1-12" ,    "Hirobumi Ito(3)",
  "1898-6-30" ,    "Shigenobu Okuma(1)",
  "1898-11-8" ,    "Aritomo Yamagata(2)",
  "1900-10-19",    "Hirobumi Ito(4)",
  "1901-6-2"  ,    "Taro Katsura(1)",
  "1906-1-7"  ,    "Kinmochi Saionji(1)",
  "1908-7-14" ,    "Taro Katsura(2)",
  "1911-8-30" ,    "Kinmochi Saionji(2)",
  "1912-12-21",    "Taro Katsura(3)",
  "1913-2-20" ,    "Gonnohyoe Yamamoto(1)",
  "1914-4-16" ,    "Shigenobu Okuma(2)",
  "1916-10-9" ,    "Masatake Terauchi",
  "1918-9-29" ,    "Takashi Hara",
  "1921-11-13",    "Korekiyo Takahashi",
  "1922-6-12" ,    "Tomosaburo Kato",
  "1923-9-2"  ,    "Gonnohyoe Yamamoto(2)",
  "1924-1-7"  ,    "Keigo Kiyoura",
  "1924-6-11" ,    "Takaaki Kato",
  "1926-1-30" ,    "Reijiro Wakatsuki(1)",
  "1927-4-20" ,    "Giichi Tanaka",
  "1929-7-2"  ,    "Osachi Hamaguchi",
  "1931-4-14" ,    "Reijiro Wakatsuki(2)",
  "1931-12-13",    "Tsuyoshi Inukai",
  "1932-5-26" ,    "Makoto Saito",
  "1934-7-8"  ,    "Keisuke Okada",
  "1936-3-9"  ,    "Koki Hirota",
  "1937-2-2"  ,    "Senjuro Hayashi",
  "1937-6-4"  ,    "Fumimaro Konoe(1)",
  "1939-1-5"  ,    "Kiichiro Hiranuma",
  "1939-8-30" ,    "Nobuyuki Abe",
  "1940-1-16" ,    "Mitsumasa Yonai",
  "1940-7-22" ,    "Fumimaro Konoe(2-3)",
  "1941-10-18",    "Hideki Tojo",
  "1944-7-22" ,    "Kuniaki Koiso",
  "1945-4-7"  ,    "Kantaro Suzuki",
  "1945-8-17" ,    "Prince Naruhiko Higashikuni",
  "1945-10-9" ,    "Kijuro Shidehara",
  "1946-5-22" ,    "Shigeru Yoshida(1)",
  "1947-5-24" ,    "Tetsu Katayama",
  "1948-3-10" ,    "Hitoshi Ashida",
  "1948-10-15",    "吉田茂(2-5)",
  "1954-12-10",    "鳩山一郎(1-3)",
  "1956-12-23",    "石橋湛山",
  "1957-2-25" ,    "岸信介(1-2)",
  "1960-7-19" ,    "池田勇人(1-3)",
  "1964-11-9" ,    "佐藤栄作(1-3)",
  "1972-7-7"  ,    "田中角栄(1-2)",
  "1974-12-9" ,    "三木武夫",
  "1976-12-24",    "福田赳夫",
  "1978-12-7" ,    "大平正芳(1-2)",
  "1980-7-17" ,    "鈴木善幸",
  "1982-11-27",    "中曽根康弘(1-3)",
  "1987-11-6" ,    "竹下登",
  "1989-6-3"  ,    "宇野宗佑",
  "1989-8-10" ,    "海部俊樹(1-2)",
  "1991-11-5" ,    "宮沢喜一",
  "1993-8-9"  ,    "細川護煕",
  "1994-4-28" ,    "羽田孜",
  "1994-6-30" ,    "村山富市",
  "1996-1-11" ,    "橋本龍太郎(1-2)",
  "1998-7-30" ,    "小渕恵三",
  "2000-4-5"  ,    "森喜朗(1-2)",
  "2001-4-26" ,    "小泉純一郎(1-3)",
  "2006-9-26" ,    "安倍晋三(1)",
  "2007-9-26" ,    "福田康夫",
  "2008-9-24" ,    "麻生太郎",
  "2009-9-16" ,    "鳩山由紀夫",
  "2010-6-8"  ,    "菅直人",
  "2011-9-2"  ,    "野田佳彦",
  "2012-12-26",    "安倍晋三(2,3)"
)
cnt <- 1
pmTable <- data.frame()
for(rrr in seq(1,length(primeMinisterOfJapan),by = 2)){
  pmTable[cnt,1] <- as.character(as.Date(primeMinisterOfJapan[rrr]))
  pmTable[cnt,2] <- as.character(as.Date(primeMinisterOfJapan[rrr+2]))
  pmTable[cnt,3] <- primeMinisterOfJapan[rrr+1]
  cnt <- cnt +1
}
pmTable[nrow(pmTable),2] <- as.character(Sys.Date())
write.table(pmTable, "clipboard", sep = "\t", row.names = F, col.names = T)
out <- NULL
for(rrr in 1:nrow(pmTable)){
  if(rrr %% 2 == 0){col <- '#FFE6E6'}else{col <- '#CCEBD6'}
  tmp1 <- paste0('dyShading(from = \'',pmTable[rrr,1],'\', to = \'',pmTable[rrr,2],'\', color = \'',col,'\') %>% ')
  if(rrr!=nrow(pmTable)){
    tmp2 <- paste0('dyEvent(\'',pmTable[rrr,2],'\',\'',pmTable[rrr,3],'\', labelLoc = \'bottom\') %>% ')
  }else{
    tmp2 <- paste0('dyEvent(\'',obj[nrow(obj),1],'\',\'',pmTable[rrr,3],'\', labelLoc = \'bottom\')')
  }
  out <- c(out, tmp1, tmp2)
}
buf0 <-paste(out, collapse = '')
assign('primeMinisterOfJapan_dygraph', buf0, envir = .GlobalEnv)
}

fun_boj <- function(obj = dataSet){
boj <- c(
  "1882-10-6" ,    "Shigetoshi Yoshihara",
  "1888-2-21" ,    "Tetsunosuke Tomita",
  "1889-9-3"  ,    "Koichiro Kawada",
  "1896-11-11",    "Yanosuke Iwasaki",
  "1898-10-20",    "Tatsuo Yamamoto",
  "1903-10-20",    "Shigeyoshi Matsuo",
  "1911-6-1"  ,    "Korekiyo Takahashi",
  "1913-2-28" ,    "Yataro Mishima",
  "1919-3-13" ,    "Junnosuke Inoue(1)",
  "1923-9-5"  ,    "Otohiko Ichiki",
  "1927-5-10" ,    "Junnosuke Inoue(2)",
  "1928-6-12" ,    "Hisaakira Hijikata",
  "1935-6-4"  ,    "Eigo Fukai",
  "1937-2-9"  ,    "Shigeaki Ikeda",
  "1937-7-27" ,    "Toyotaro Yuki",
  "1944-3-18" ,    "渋澤敬三",
  "1945-10-9" ,    "新木栄吉(1)",
  "1946-6-1"  ,    "一萬田尚登",
  "1954-12-11",    "新木栄吉(2)",
  "1956-11-30",    "山際正道",
  "1964-12-17",    "宇佐美洵",
  "1969-12-17",    "佐々木直",
  "1974-12-17",    "森永貞一郎",
  "1979-12-17",    "前川春夫",
  "1984-12-17",    "澄田智",
  "1989-12-17",    "三重野康",
  "1994-12-17",    "松下康夫",
  "1998-3-20" ,    "速水優",
  "2003-3-20" ,    "福井俊彦",
  "2008-4-9"  ,    "白川正明",
  "2013-3-20" ,    "黒田東彦"
)
cnt <- 1
bojTable <- data.frame()
for(rrr in seq(1,length(boj),by = 2)){
  bojTable[cnt,1] <- as.character(as.Date(boj[rrr]))
  bojTable[cnt,2] <- as.character(as.Date(boj[rrr+2]))
  bojTable[cnt,3] <- boj[rrr+1]
  cnt <- cnt +1
}
bojTable[nrow(bojTable),2] <- as.character(Sys.Date())
write.table(bojTable, "clipboard", sep = "\t", row.names = F, col.names = T)
out <- NULL
for(rrr in 1:nrow(bojTable)){
  if(rrr %% 2 == 0){col <- '#FFE6E6'}else{col <- '#CCEBD6'}
  tmp1 <- paste0('dyShading(from = \'',bojTable[rrr,1],'\', to = \'',bojTable[rrr,2],'\', color = \'',col,'\') %>% ')
  if(rrr!=nrow(bojTable)){
    tmp2 <- paste0('dyEvent(\'',bojTable[rrr,2],'\',\'',bojTable[rrr,3],'\', labelLoc = \'bottom\') %>% ')
  }else{
    tmp2 <- paste0('dyEvent(\'',obj[nrow(obj),1],'\',\'',bojTable[rrr,3],'\', labelLoc = \'bottom\')')
  }
  out <- c(out, tmp1, tmp2)
}
buf0 <-paste(out, collapse = '')
assign('boj_dygraph', buf0, envir = .GlobalEnv)
}

fun_event <- function(obj = dataSet){
eventRange <-c(
  "2013-09-08",as.character(obj[nrow(obj),1]),"2020年東京オリンピック決定",
  "1986-12-01","1991-02-01","バブル景気",
  "1997-01-01","1998-01-01","アジア通貨危機"
)
event <- c(
  as.character(obj[nrow(obj),1]),"2020年東京オリンピック決定",
  "1998-01-01","アジア通貨危機",
  "1991-02-01","バブル景気",
  "2008-09-15","リーマン･ブラザーズ破綻",
  "2016-11-08","2016年アメリカ合衆国大統領選挙",
  "2011-03-11","東日本大震災",
  "1995-01-17","阪神･淡路大震災",
  "1985-09-22","プラザ合意",
  # "1971-12-18","スミソニアン協定",
  "1990-03-27","総量規制",
  "1987-10-19","ブラックマンデー",
  "1987-02-22","ルーブル合意"
)
event <- iconv(event,'shift_jis','utf8')
cnt <- 1
eventTable <- data.frame()
for(rrr in seq(1,length(event),by = 2)){
  eventTable[cnt,1] <- as.character(as.Date(event[rrr]))
  eventTable[cnt,2] <- event[rrr+1]
  cnt <- cnt +1
}
cnt <- 1
eventRangeTable <- data.frame()
for(rrr in seq(1,length(eventRange),by = 3)){
  eventRangeTable[cnt,1] <- as.character(as.Date(eventRange[rrr]))
  eventRangeTable[cnt,2] <- as.character(as.Date(eventRange[rrr+1]))
  eventRangeTable[cnt,3] <- eventRange[rrr+2]
  cnt <- cnt +1
}
out <- NULL
for(rrr in 1:nrow(eventRangeTable)){
  if(rrr %% 2 == 0){col <- '#FFE6E6'}else{col <- '#CCEBD6'}
  tmp <- paste0('dyShading(from = \'',eventRangeTable[rrr,1],'\', to = \'',eventRangeTable[rrr,2],'\', color = \'',col,'\')')
  out <- c(out, tmp)
}
buf0 <-paste(out, collapse = ' %>% ')
assign('event_dygraph_range', buf0,envir = .GlobalEnv)
out <- NULL
for(rrr in seq(1,length(event),by=2)){
  if(obj[1,1]<= event[rrr]){
    tmp <- paste0('dyEvent(\'',event[rrr],'\',\'',event[rrr+1],'\', labelLoc = \'bottom\')')
    out <- c(out, tmp)
  }
}
buf1 <-paste(out, collapse = ' %>% ')
assign('event_dygraph_point', buf1,envir = .GlobalEnv)
}

fun_plot_dygraph <- function(obj = tmp, plotNum = 1, dygraphTitle = '', legendWidth = 600, barPlot = 0, colors = colors){
  buf <- na.omit(obj)
  fun_dygraph(obj = buf, mainTitle = dygraphTitle, plotNum = plotNum, legendWidth = legendWidth, barPlot0 = barPlot, colors = colors)
  fun_consumptionTax(obj = buf)
  fun_primeMinisterOfJapan(obj = buf)
  fun_boj(obj = buf)
  fun_event(obj = buf)
}

fun_dygraph_shade <- function(plotNum = 1){
  assign(paste0('knit_expanded',plotNum),
         paste0(
           "\n```{r warning=F, error=F, message=F, echo=F, results='asis'}\n\n",
           "eval(parse(text = paste0('dygraphPlot", plotNum," %>% ', ConsumptionTax)))",
           "\n\ncat('<hr>')\n\n```",
           "\n```{r warning=F, error=F, message=F, echo=F, results='asis'}\n\n",
           "eval(parse(text = paste0('dygraphPlot", plotNum," %>% ', primeMinisterOfJapan_dygraph)))",
           "\n\ncat('<hr>')\n\n```",
           "\n```{r warning=F, error=F, message=F, echo=F, results='asis'}\n\n",
           "eval(parse(text = paste0('dygraphPlot", plotNum," %>% ', boj_dygraph)))",
           "\n\ncat('<hr>')\n\n```",
           "\n```{r warning=F, error=F, message=F, echo=F, results='asis'}\n\n",
           "eval(parse(text = paste0('dygraphPlot", plotNum," %>% ', event_dygraph_point,' %>%  ',event_dygraph_range)))",
           "\n\ncat('<hr>')\n\n```"),envir = .GlobalEnv)
}

fun_generateKnit <-
  function(objDF = dataSet, plotNum = 1, barPlot = 0, dygraphTitle = '',
           legendWidth = 300, colors = RColorBrewer::brewer.pal(3, "Set2")){
  fun_plot_dygraph(obj = objDF, plotNum = plotNum,
                   dygraphTitle = dygraphTitle,
                   legendWidth = legendWidth, barPlot = barPlot, colors = colors)
  fun_dygraph_shade(plotNum = plotNum)
}
