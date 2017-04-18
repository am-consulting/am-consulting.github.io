# Source OECD,FRED
library(quantmod)
yield10year <-
  c(
    'IRLTLT01DEM156N','Long-Term Government Bond Yields: 10-year: Main (Including Benchmark) for Germany©',
    'IRLTLT01USM156N','Long-Term Government Bond Yields: 10-year: Main (Including Benchmark) for the United States©',
    'IRLTLT01JPM156N','Long-Term Government Bond Yields: 10-year: Main (Including Benchmark) for Japan©',
    'IRLTLT01GRM156N','Long-Term Government Bond Yields: 10-year: Main (Including Benchmark) for Greece©',
    'IRLTLT01GBM156N','Long-Term Government Bond Yields: 10-year: Main (Including Benchmark) for the United Kingdom©',
    'IRLTLT01FRM156N','Long-Term Government Bond Yields: 10-year: Main (Including Benchmark) for France©',
    'IRLTLT01CAM156N','Long-Term Government Bond Yields: 10-year: Main (Including Benchmark) for Canada©',
    'IRLTLT01ITM156N','Long-Term Government Bond Yields: 10-year: Main (Including Benchmark) for Italy©',
    'IRLTLT01ESM156N','Long-Term Government Bond Yields: 10-year: Main (Including Benchmark) for Spain©',
    'IRLTLT01ZAM156N','Long-Term Government Bond Yields: 10-year: Main (Including Benchmark) for South Africa©',
    'IRLTLT01MXM156N','Long-Term Government Bond Yields: 10-year: Main (Including Benchmark) for Mexico©',
    'IRLTLT01EZM156N','Long-Term Government Bond Yields: 10-year: Main (Including Benchmark) for the Euro Area©',
    'IRLTLT01AUM156N','Long-Term Government Bond Yields: 10-year: Main (Including Benchmark) for Australia©',
    'IRLTLT01IEM156N','Long-Term Government Bond Yields: 10-year: Main (Including Benchmark) for Ireland©',
    'IRLTLT01RUM156N','Long-Term Government Bond Yields: 10-year: Main (Including Benchmark) for the Russian Federation©',
    'IRLTLT01SEM156N','Long-Term Government Bond Yields: 10-year: Main (Including Benchmark) for Sweden©',
    'IRLTLT01CHM156N','Long-Term Government Bond Yields: 10-year: Main (Including Benchmark) for Switzerland©',
    'IRLTLT01NOM156N','Long-Term Government Bond Yields: 10-year: Main (Including Benchmark) for Norway©',
    'IRLTLT01NLM156N','Long-Term Government Bond Yields: 10-year: Main (Including Benchmark) for the Netherlands©',
    'IRLTLT01PTM156N','Long-Term Government Bond Yields: 10-year: Main (Including Benchmark) for Portugal©',
    'IRLTLT01FIM156N','Long-Term Government Bond Yields: 10-year: Main (Including Benchmark) for Finland©',
    'IRLTLT01PLM156N','Long-Term Government Bond Yields: 10-year: Main (Including Benchmark) for Poland©',
    'IRLTLT01KRM156N','Long-Term Government Bond Yields: 10-year: Main (Including Benchmark) for the Republic of Korea©',
    'IRLTLT01BEM156N','Long-Term Government Bond Yields: 10-year: Main (Including Benchmark) for Belgium©',
    'IRLTLT01NZM156N','Long-Term Government Bond Yields: 10-year: Main (Including Benchmark) for New Zealand©',
    'IRLTLT01SKM156N','Long-Term Government Bond Yields: 10-year: Main (Including Benchmark) for the Slovak Republic©',
    'IRLTLT01CLM156N','Long-Term Government Bond Yields: 10-year: Main (Including Benchmark) for Chile©',
    'IRLTLT01DKM156N','Long-Term Government Bond Yields: 10-year: Main (Including Benchmark) for Denmark©',
    'IRLTLT01ATM156N','Long-Term Government Bond Yields: 10-year: Main (Including Benchmark) for Austria©',
    'IRLTLT01LUM156N','Long-Term Government Bond Yields: 10-year: Main (Including Benchmark) for Luxembourg©',
    'IRLTLT01HUM156N','Long-Term Government Bond Yields: 10-year: Main (Including Benchmark) for Hungary©',
    'IRLTLT01ILM156N','Long-Term Government Bond Yields: 10-year: Main (Including Benchmark) for Israel©',
    'IRLTLT01SIM156N','Long-Term Government Bond Yields: 10-year: Main (Including Benchmark) for Slovenia©',
    'IRLTLT01ISM156N','Long-Term Government Bond Yields: 10-year: Main (Including Benchmark) for Iceland©',
    'IRLTLT01CZM156N','Long-Term Government Bond Yields: 10-year: Main (Including Benchmark) for the Czech Republic©'
    )
for(iii in seq(1,length(yield10year),by = 2)){
  tmp <-
    getSymbols(yield10year[iii],
               src = "FRED",
               auto.assign = F)
  if(iii == 1){yield10yearData <- tmp}else{yield10yearData <- merge(yield10yearData,tmp)}
}
colnames(yield10yearData) <-
  gsub('.+for\\s(.+)c','\\1',yield10year[seq(2,length(yield10year),by = 2)])
yield10yearData <-
  data.frame(Date = index(yield10yearData),yield10yearData,
             stringsAsFactors = F,check.names = F,row.names = NULL)
