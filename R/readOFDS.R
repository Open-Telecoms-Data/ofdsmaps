#' Read in OFDS JSON data
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
    
    fill_empty <- function(field){
      out <- ifelse(is.null(field),'No data',field)
    }
    
    span_df <- function(span){
      coord_list <- span$route$coordinates
      coord_mat <- matrix(unlist(coord_list),ncol = 2, byrow = TRUE)
      colnames(coord_mat) <- c('long','lat')
      out <- tibble::as_tibble(coord_mat)
      out$name <- fill_empty(span$name)
      out$networkname <- fill_empty(j$networks[[1]]$name)
      out$phase <- fill_empty(span$phase$name)
      out$physicalInfrastructureProvider <- fill_empty(span$physicalInfrastructureProvider$name)
      out$supplier <- fill_empty(span$supplier$name)
      out$status <- fill_empty(span$status)
      out$fibreType <- fill_empty(span$fibreType)
      out$transmissionMedium <- fill_empty(span$transmissionMedium)
      out$none <- 'None'
      return(out)
    }
    node_df <- function(node){
      coord_list <- node$location$coordinates
      coord_mat <- matrix(unlist(coord_list),ncol = 2, byrow = TRUE)
      colnames(coord_mat) <- c('long','lat')
      out <- tibble::as_tibble(coord_mat)
      out$name <- fill_empty(node$name)
      out$networkname <- fill_empty(j$networks[[1]]$name)
      out$phase <- fill_empty(node$phase$name)
      out$physicalInfrastructureProvider <- fill_empty(node$physicalInfrastructureProvider$name)
      out$status <- fill_empty(node$status)
      out$type <- fill_empty(node$type)
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