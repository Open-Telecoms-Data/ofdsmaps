#' Plot OFDS data on a map
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
#' @importFrom pals alphabet
#' @importFrom tibble tibble
#' @export
#'
#' @examples
#' \dontrun{
#' dflist <- readOFDS()
#' mapOFDS(dflist,
#' spancol = 'networkname',
#' nodecol = 'networkname',
#' nodelegend = FALSE,
#' spanlegend = FALSE)}

mapOFDS <- function(ofdslist,
                    spancol = 'networkname',
                    nodecol = 'networkname',
                    colpal =  unname(pals::alphabet(16)),
                    spanlegend = TRUE,
                    nodelegend = TRUE){

    m <- leaflet::leaflet() %>%
    leaflet::addTiles()
  
  colpal <- colpal[2:16]
    
  for(i in 1:length(ofdslist$spans)) {
    span <- ofdslist$spans[[i]]
    spanlegend_lab <- unlist(span[spancol],use.names = FALSE)[1]

    if(i == 1){
      spanlegend_labs <- spanlegend_lab
      spanlegend_col <- colpal[which(spanlegend_labs == spanlegend_lab)]
      spanlegend_cols <- spanlegend_col
    } else{
      if(!spanlegend_lab %in% spanlegend_labs){
        spanlegend_labs <- c(spanlegend_labs,spanlegend_lab)
      }
      spanlegend_col <- colpal[which(spanlegend_labs == spanlegend_lab)]
      if(!spanlegend_col %in% spanlegend_cols){
        spanlegend_cols <- c(spanlegend_cols,spanlegend_col)
      }
    }
    
    
    m  <- m %>% 
      leaflet::addPolylines(lng = span$long,
                            lat = span$lat,
                            popup = paste0('Network: ',span$networkname,'<br>',
                                           'Span: ',span$name, '<br>',
                                           'Phase: ',span$phase, '<br>',
                                           'Physical infrastructure provider: ',span$physicalInfrastructureProvider, '<br>',
                                           'Supplier: ',span$supplier, '<br>',
                                           'Status: ',span$status, '<br>',
                                           'Fibre type: ',span$fibreType, '<br>',
                                           'Transmission medium: ', span$transmissionMedium),
                            color = spanlegend_col,
                            weight = 2,
                            opacity = 0.9)
  }
  
  for(i in 1:length(ofdslist$nodes)){
    node <- ofdslist$nodes[[i]]
    nodelegend_lab <- unlist(node[nodecol],use.names = FALSE)[1]
    
    if(i == 1){
      nodelegend_labs <- nodelegend_lab
      if(nodelegend_lab %in% spanlegend_labs){
        nodelegend_col <- colpal[which(spanlegend_labs == nodelegend_lab)]
      } else{
        nodelegend_col <- colpal[length(spanlegend_cols)+1]
      }
      nodelegend_cols <- nodelegend_col
      
    } else{
      if(!nodelegend_lab %in% nodelegend_labs){
        nodelegend_labs <- c(nodelegend_labs,nodelegend_lab)
      }
      if(nodelegend_lab %in% spanlegend_labs){
        nodelegend_col <- colpal[which(spanlegend_labs == nodelegend_lab)]
      } else{
        nodelegend_col <- colpal[length(spanlegend_labs)+which(nodelegend_labs == nodelegend_lab)]
      }
      if(!nodelegend_col %in% nodelegend_cols){
        nodelegend_cols <- c(nodelegend_cols,nodelegend_col)
      }
    }
    
    m  <- m %>% 
      leaflet::addCircleMarkers(lng = node$long,
                          lat = node$lat,
                          popup = paste('Network: ',node$networkname, '<br>',
                                        'Node: ', node$name, '<br>',
                                        'Phase: ', node$phase, '<br>',
                                        'Physical infrastructure provider: ',node$physicalInfrastructureProvider, '<br>',
                                        'Status: ',node$status, '<br>',
                                        'Type: ',node$type),
                          color = nodelegend_col,
                          weight = 1,
                          opacity = 0.9,
                          fillOpacity = 0.6,
                          radius = 5)
  }
    
  if(spanlegend)
  {
    m <- m %>%
      addLegend(colors = spanlegend_cols,
                labels = spanlegend_labs,
                position = 'bottomright',
                title = 'Spans',
                opacity = 0.9)
  }
    if(nodelegend)
    {
      m <- m %>%
        addLegend(colors = nodelegend_cols,
                  labels = nodelegend_labs,
                  position = 'bottomleft',
                  title = 'Nodes',
                  opacity = 0.6)
    }
    
  return(m)
}

