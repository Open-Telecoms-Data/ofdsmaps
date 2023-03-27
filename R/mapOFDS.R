#' Title
#'
#' @param ofdslist a list of OFDS objects generates from readOFDS
#' @param nodecol the variable to colour nodes by
#' @param spancol the variable to colour spans by
#' @param colpal a colour palette for node and span colours
#' @param spanlegend logical - show legend?
#' @param nodelegend logical - show legend?
#'
#' @return a leaflet map
#' @importFrom leaflet leaflet addPolylines addMarkers addTiles addLegend
#' @importFrom dplyr %>%
#' @importFrom paletteer paletteer_dynamic
#' @export
#'
#' @examples
#' \dontrun{
#' flist <- readOFDS('myfolder')
#' mapOFDS(dflist,
#' spancol = 'networkname',
#' nodecol = 'networkname',
#' nodelegend = FALSE,
#' spanlegend = FALSE)}

mapOFDS <- function(ofdslist, spancol = 'networkname', nodecol = 'networkname', colpal =  paletteer_dynamic("cartography::multi.pal", 20), spanlegend = TRUE,nodelegend = TRUE){

    m <- leaflet::leaflet() %>%
    leaflet::addTiles()
    
  
  for(i in 1:length(ofdslist$spans)) {
    span <- ofdslist$spans[[i]]
    if(i == 1){
      spancolvar <- unlist(span[1,spancol])
    } else {
      spancolvar <- c(spancolvar,unlist(span[1,spancol]))
    }
    spancolvar <- unique(spancolvar)
    col = colpal[which(spancolvar == unlist(span[1,spancol]))]
    
    m  <- m %>% 
      leaflet::addPolylines(lng = span$long,
                            lat = span$lat,
                            popup = paste0('Network: ',span$networkname,'<br>',
                                           'Span: ',span$name, '<br>',
                                           'Physical infrastructure provider: ',span$physicalInfrastructureProvider, '<br>',
                                           'Status: ',span$status, '<br>',
                                           'Fibre type: ',span$fibreType),
                            color = col)
  }
  
  for(i in 1:length(ofdslist$nodes)){
    node <- ofdslist$nodes[[i]]
    if(i == 1){
      nodecolvar <- unlist(node[1,nodecol])
    } else {
      nodecolvar <- c(nodecolvar,unlist(node[1,nodecol]))
    }
    nodecolvar <- unique(nodecolvar)
    col = colpal[which(nodecolvar == unlist(node[1,nodecol]))]
    
    m  <- m %>% 
      leaflet::addCircleMarkers(lng = node$long,
                          lat = node$lat,
                          popup = paste('Network: ',node$networkname, '<br>',
                                        'Node: ', node$name, '<br>',
                                        'Physical infrastructure provider: ',node$physicalInfrastructureProvider, '<br>',
                                        'Status: ',node$status, '<br>',
                                        'Access point: ',node$accessPoint),
                          color = col)
  }
    
  if(spanlegend)
  {
    m <- m %>%
      addLegend(colors = colpal[1:length(spancolvar)],
                labels = spancolvar,
                position = 'bottomright',
                title = 'Spans')
  }
    if(nodelegend)
    {
      m <- m %>%
        addLegend(colors = colpal[1:length(nodecolvar)],
                  labels = nodecolvar,
                  position = 'bottomleft',
                  title = 'Nodes')
    }
    
  return(m)
}

