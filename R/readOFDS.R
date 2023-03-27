#' Title
#'
#' @param dir A url to a Google drive directory containing OFDS JSON objects
#'
#' @return a list of data frames
#' @importFrom jsonlite read_json
#' @importFrom purrr map
#' @importFrom tibble as_tibble
#' @importFrom googledrive drive_ls as_id drive_download
#' 
#' @export
#'
#' @examples
#' \dontrun{
#' downloadOFDS('exampleURL.com')
#' dflist <- readOFDS('data/Kenya')
#' }
#'
#'
readOFDS <- function(dir){


  readSingleOFDS <- function(jsonfile)
  {
    j <- jsonlite::read_json(jsonfile)
    
    if(length(j$networks) > 1){
      warning('Your file has more than one network, only the first network will be used')
    }
    
    spans_list <- j$networks[[1]]$spans
    nodes_list <- j$networks[[1]]$nodes
    
    
    span_df <- function(span){
      coord_list <- span$route$coordinates
      coord_mat <- matrix(unlist(coord_list),ncol = 2, byrow = TRUE)
      colnames(coord_mat) <- c('long','lat')
      out <- tibble::as_tibble(coord_mat)
      out$name <- span$name
      out$networkname <- j$networks[[1]]$name
      out$physicalInfrastructureProvider <- span$physicalInfrastructureProvider$name
      out$status <- span$status
      out$fibreType <- span$fibreType
      out$none <- 'None'
      return(out)
    }
    node_df <- function(node){
      coord_list <- node$location$coordinates
      coord_mat <- matrix(unlist(coord_list),ncol = 2, byrow = TRUE)
      colnames(coord_mat) <- c('long','lat')
      out <- tibble::as_tibble(coord_mat)
      out$name <- node$name
      out$networkname <- j$networks[[1]]$name
      out$physicalInfrastructureProvider <- node$physicalInfrastructureProvider$name
      out$status <- node$status
      out$accessPoint <- node$accessPoint
      out$none <- 'None'
      return(out)
    }
    
    spans <- purrr::map(spans_list, ~ span_df(.))
    nodes <- purrr::map(nodes_list, ~ node_df(.))
    
    out <- list(nodes = nodes,spans = spans)
    
    return(out) 
  }

  jsonfiles <- list.files(dir,pattern = '*.json')
  for (i in 1:length(jsonfiles)) {
    if(i == 1){
      out <- readSingleOFDS(paste0(dir,'/',jsonfiles[i]))
    } else{
      l <- readSingleOFDS(paste0(dir,'/',jsonfiles[i]))
      out$nodes <- c(out$nodes,l$nodes)
      out$spans <- c(out$spans,l$spans)
    }
  }
  
  return(out)

}