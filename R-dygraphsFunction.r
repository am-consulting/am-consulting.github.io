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

fun_dygraph <- function(obj = dataSet, mainTitle = "", legendWidth = 600, hairDirection = 'both'){
  xtsData <- xts(obj[,-1], order.by=obj[,1])
  colnames(xtsData) <- colnames(obj)[-1]
  dygraphPlot <-
    dygraph(xtsData, main = mainTitle, group = 'amcc') %>%
    dyLegend(width = legendWidth) %>%
    dyRangeSelector() %>%
    dyUnzoom() %>% dyCrosshair(direction = hairDirection)
  assign('dygraphPlot', dygraphPlot, envir = .GlobalEnv)
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
