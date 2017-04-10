username <-
  Sys.info()['user']
pathToFile <-
  paste0('C:/Users/', username,'/Desktop/pathToCSV/')
setwd(pathToFile)
fileName <-
  'defaultPath.csv'
buf <-
  read.csv(file = fileName,header = F,skip = 0,
           stringsAsFactor = F,check.names = F,fileEncoding = 'utf-8')
pathOutputTOcsv <-
  paste0("C:/Users/", username, buf[2,1],'csv/ListOfPresidents/')
setwd(pathOutputTOcsv)
getwd()

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

potus <- c(
  "1933-3-4"  ,    "Franklin Delano Roosevelt",
  "1945-4-12" ,    "Harry S. Truman",
  "1953-1-20" ,    "Dwight David Eisenhower",
  "1961-1-20" ,    "John Fitzgerald Kennedy",
  "1963-11-22",    "Lyndon Baines Johnson",
  "1969-1-20" ,    "Richard Milhouse Nixon",
  "1974-8-9"  ,    "Gerald Rudolph Ford Jr.",
  "1977-1-20" ,    "James Earl Carter",
  "1981-1-20" ,    "Ronald Wilson Reagan",
  "1989-1-20" ,    "George H.W Bush",
  "1993-1-20" ,    "Bill Clinton",
  "2001-1-20" ,    "George W. Bush",
  "2009-1-20" ,    "Barack Obama",
  "2017-1-20" ,    "Donald Trump"
)

frb <- c(
  "1934-11-15",    "Marriner Eccles",
  "1948-4-15" ,    "Thomas B. McCabe",
  "1951-4-2"  ,    "William M. Martin",
  "1970-2-1"  ,    "Arthur F.Burns",
  "1978-3-8"  ,    "G.William Miller",
  "1987-8-11" ,    "Alan Greenspan",
  "2006-2-1"  ,    "Ben S.Bernanke",
  "2014-2-1"  ,    "Janet Yellen"
)

fun_list <- function(obj,csvfileName){
cnt <- 1
dfTable <- data.frame()
for(rrr in seq(1,length(obj),by = 2)){
  dfTable[cnt,1] <- as.Date(obj[rrr])
  dfTable[cnt,2] <- as.Date(obj[rrr+2])
  dfTable[cnt,3] <- obj[rrr+1]
  cnt <- cnt +1
}
dfTable[nrow(dfTable),2] <- Sys.Date()
dfTable[,1] <- as.Date(dfTable[,1], origin = "1970-01-01")
dfTable[,2] <- as.Date(dfTable[,2], origin = "1970-01-01")
write.csv(x = dfTable,file = csvfileName,
          quote = T,row.names = F,append = F,fileEncoding = 'utf8')
}
fun_list(obj = primeMinisterOfJapan,csvfileName = 'primeMinisterOfJapan.csv')
fun_list(obj = boj,csvfileName = 'boj.csv')
fun_list(obj = potus,csvfileName = 'potus.csv')
fun_list(obj = frb,csvfileName = 'frb.csv')
