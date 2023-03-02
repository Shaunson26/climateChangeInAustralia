#' Create CCIA dataset URL request
#'
#' @description
#' Start the process of building a CCIA dataset URL request. This function takes
#' a relative URL (see [climateChangeInAustralia::ccia_dataset_urls()]) and a given
#' access type and creates a [httr2::request()]
#'
#' @param dataset_relative_url relative URL from the dataset download page.
#' Loaded into R session with [climateChangeInAustralia::ccia_dataset_urls()]
#' @param access_type dataset type to download.
#'
#' @details
#' There are two base URLs and internal URL paths depending on the dataset type (Projected change
#' or Plausible future climate data and Threshold datasets). This function builds
#' the URL given the dataset and access type https://<dataset-path>/<access-path>/<dataset-path2>
#'
#' @return An HTTP response: an S3 list with class httr2_request.
#'
#' @export
ccia_create_dataset_request_url <-
  function(dataset_relative_url,
           access_type = c('NetcdfSubset',
                           'OPENDAP',
                           'HTTPServer',
                           'WMS',
                           'WCS',
                           'NCML',
                           'UDDC',
                           'ISO')) {

    access_type <-
      match.arg(access_type,
                choices = c('NetcdfSubset',
                            'OPENDAP',
                            'HTTPServer',
                            'WMS',
                            'WCS',
                            'NCML',
                            'UDDC',
                            'ISO'))

    # paste root with value
    base_url <-
      ifelse(
        grepl('Projected_Change_Data', dataset_relative_url),
        yes = 'https://dapds00.nci.org.au/thredds',
        no = 'https://data-cbr.csiro.au/thredds'
      )

    access_type_path <-
      switch(access_type,
             'NetcdfSubset' = 'ncss',
             'OPENDAP' = 'dods',
             'HTTPServer' = 'fileServer',
             'WMS' = 'wms',
             'WCS' = 'wcs',
             'NCML' = 'ncml',
             'UDDC' = 'uddc',
             'ISO' = 'iso')

    dataset_prefix_path <-
      ifelse(
        grepl('Projected_Change_Data', dataset_relative_url),
        yes = '',
        no = 'catch_all'
      )

    # create request
    httr2::request(base_url) |>
      httr2::req_url_path_append(access_type_path) |>
      httr2::req_url_path_append(dataset_prefix_path) |>
      httr2::req_url_path_append(dataset_relative_url)

  }
