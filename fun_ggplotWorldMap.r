fun_ggplotWorldMap <- function(fill = 'grey80',color = 'white',ratio = 1.1){
  library(ggplot2)
  worldMapData <- map_data(map="world")
  worldMap <-
    ggplot(data = worldMapData,aes(x = long,y = lat)) +
    geom_polygon(data = worldMapData,fill = fill,aes(group = group)) +
    geom_path(color = color,aes(group = group)) +
    coord_fixed(ratio = ratio)
  return(worldMap)
}
