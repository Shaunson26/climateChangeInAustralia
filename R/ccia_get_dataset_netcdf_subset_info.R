#' Get dataset description in easy to view and handle manner
#'
#' Obtain the dataset description XML and wrangle into a list. Works only
#' for NetcdfSubset URLs.
#'
#' @param request httr2 request with 'NetcdfSubset' access type
#'
#' @details
#' Uses [climateChangeInAustralia::ccia_get_dataset_netcdf_subset_description_xml()]
#' to obtain the XML and then [climateChangeInAustralia::ccia_extract_dataset_xml_data()]
#'
#' @return a list
#'
#' @export
ccia_get_dataset_netcdf_subset_info <- function(request){

  is_netcdf_request <- grepl('ncss', request$url)
  stopifnot(is_netcdf_request)

  dataset_xml <-
    ccia_get_dataset_netcdf_subset_description_xml(request)

  ccia_extract_dataset_xml_data(dataset_xml)

}
