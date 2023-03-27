#' Download OFDS data from Google drive
#'
#' @param country A country folder on Google Drive - Currently must be 'Ghana' or 'Kenya'
#' @param overwrite logical - overwirte existing data?
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
#' downloadOFDS('Ghana')
#' }
#' 
downloadOFDS <- function(country, overwrite = FALSE){
  
  if(country == 'Ghana'){
    url <- 'https://drive.google.com/drive/folders/1-_NcQltK0ipD6du-FfeiCmSddP9vCjVu'
  }
  if(country == 'Kenya'){
    url <- 'https://drive.google.com/drive/folders/1D6jtp7sryUm5_ArBEyZrlaYpHTWnR5Gu'
    }
  
  if((length(list.files(paste0('data/',country))) == 0) | overwrite)
  {
    ls_tibble <- googledrive::drive_ls(googledrive::as_id(url))
    for (i in 1:length(ls_tibble$id)) {
        googledrive::drive_download(as_id(ls_tibble$id[i]),
                                  path = paste0('data/',country,'/',ls_tibble$name[i]),
                                  overwrite = overwrite)
    }
  }
}
