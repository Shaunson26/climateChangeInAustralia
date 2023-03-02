#' Get dataset description XML
#'
#' Get data description XML from a build dataset URL (before query parameters added)
#'
#' @param request httr2 request with 'NetcdfSubset' access type
#'
#' @return an `xml2::xml_document`
#'
#' @export
ccia_get_dataset_netcdf_subset_description_xml <- function(request){

  resp <-
    request |>
    httr2::req_url_path_append('dataset.xml') |>
    httr2::req_perform()

  if (httr2::resp_status(resp) == 200) {
    resp |>
      httr2::resp_body_xml()
  }

}
