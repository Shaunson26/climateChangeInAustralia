#' Recurse through the CSIRO catalog to obtain all dataset URLs
#'
#' Used to create a catalog JSON
#'
#' @param destfile where to save the JSON
#'
save_data_urls_to_json <- function(destfile = 'inst/dataset-urls.json'){

  links <-
    lapply(catalog_root_urls, get_dataset_links)

  links$projected_change_data$rootURL <-
    'https://dapds00.nci.org.au/thredds'

  links$application_ready_daily$rootURL <-
    'https://data-cbr.csiro.au/thredds/ncss/catch_all'

  links$application_ready_aggregated$rootURL <-
    'https://data-cbr.csiro.au/thredds/ncss/catch_all'

  links$application_ready_threshold$rootURL <-
    'https://data-cbr.csiro.au/thredds/ncss/catch_all'

  links |>
    jsonlite::write_json(destfile, pretty = TRUE, auto_unbox = TRUE)

}

#' Source data root URL path
#'
catalog_root_urls <-
  list(
    projected_change_data = 'https://dapds00.nci.org.au/thredds/catalog/ua6_4/CMIP5/derived/Collections/Projected_Change_Data/catalog.xml',
    application_ready_daily = 'https://data-cbr.csiro.au/thredds/catalog/catch_all/oa-aus5km/Climate_Change_in_Australia_User_Data/Application_Ready_Data_Gridded_Daily/catalog.html',
    application_ready_aggregated = 'https://data-cbr.csiro.au/thredds/catalog/catch_all/oa-aus5km/Climate_Change_in_Australia_User_Data/Application_Ready_Data_Gridded_Aggregates/catalog.html',
    application_ready_threshold = 'https://data-cbr.csiro.au/thredds/catalog/catch_all/oa-aus5km/Climate_Change_in_Australia_User_Data/Application_Ready_Data_Gridded_Thresholds/catalog.html'
  )

#' Recurse through a catalog.xml to find dataset links
#'
#' Simulates clicking through the catalog as viewed in the brower, but by examing
#' web links.
#'
#' @param url the top level URL to start searching
#' @param .test boolean, used in testing to only recurse 2 levels at maximum
#'
#' @examples \dontrun{
#'
#' url_root <-
#'   file.path('https://dapds00.nci.org.au/thredds/catalog',
#'   'ua6_4/CMIP5/derived/Collections/Projected_Change_Data')
#'
#' datasets_many <- get_dataset_links(url = url_root)
#'
#' url_root <-
#'   file.path('https://dapds00.nci.org.au/thredds/catalog',
#'   'ua6_4/CMIP5/derived/Collections/Projected_Change_Data/Drought')
#'
#' datasets_drought <- get_dataset_links(url = url_root)
#' }

# url = catalog_root_urls$application_ready_threshold
# links = NULL
#
# url = 'https://data-cbr.csiro.au/thredds/catalog/catch_all/oa-aus5km/Climate_Change_in_Australia_User_Data/Application_Ready_Data_Gridded_Thresholds/catalog.html'
# links = 'Minimum_Temperature/catalog.html'
#
# url = 'https://data-cbr.csiro.au/thredds/catalog/catch_all/oa-aus5km/Climate_Change_in_Australia_User_Data/Application_Ready_Data_Gridded_Thresholds/Minimum_Temperature/catalog.html'
# links = "2016-2045/catalog.html"
#
# url = 'https://data-cbr.csiro.au/thredds/catalog/catch_all/oa-aus5km/Climate_Change_in_Australia_User_Data/Application_Ready_Data_Gridded_Thresholds/Minimum_Temperature/2016-2045/catalog.html'
# links = "mon/catalog.html"

#url = catalog_root_urls$projected_change_data
#links = NULL
#
#url = 'https://data-cbr.csiro.au/thredds/catalog/catch_all/oa-aus5km/Climate_Change_in_Australia_User_Data/Application_Ready_Data_Gridded_Thresholds/catalog.html'
#links = 'Minimum_Temperature/catalog.html'
#
# url = 'https://data-cbr.csiro.au/thredds/catalog/catch_all/oa-aus5km/Climate_Change_in_Australia_User_Data/Application_Ready_Data_Gridded_Thresholds/Minimum_Temperature/catalog.html'
# links = "2016-2045/catalog.html"
#
# url = 'https://data-cbr.csiro.au/thredds/catalog/catch_all/oa-aus5km/Climate_Change_in_Australia_User_Data/Application_Ready_Data_Gridded_Thresholds/Minimum_Temperature/2016-2045/catalog.html'
# links = "mon/catalog.html"
get_dataset_links <- function(url, .test = FALSE){

  result <- list()

  message('Searching: ', url)

  html <- xml2::read_html(url)

  if (grepl('xml$', url)) {

    catalog_refs <-
      html |>
      xml2::xml_find_all('//catalogref') |>
      xml2::xml_attr('xlink:href')
  }

  if (grepl('html$', url)) {

    html_hrefs <-
      html |>
      xml2::xml_find_all('//a[contains(@href,"catalog")]') |>
      xml2::xml_attr('href')

    catalog_refs <-
      grep('catalog.html$', html_hrefs, value = TRUE)

    catalog_refs <-
      grep('/thredds/catalog.html', catalog_refs, value = TRUE, invert = TRUE)

  }

  if (length(catalog_refs) == 0){

    if (grepl('xml$', url)) {

      dataset_refs <-
        html |>
        xml2::xml_find_all('//dataset') |>
        dataset_nodeset_to_df()

      message('  found: ', nrow(dataset_refs), ' datasets')

      dataset_list <-
        as.list(dataset_refs$urlpath)

      names(dataset_list) <- dataset_refs$name

    }

    if (grepl('html$', url)) {

      dataset_refs <-
        grep('/thredds/catalog.html', html_hrefs, value = TRUE, invert = TRUE)

      dataset_refs <-
        grep('\\.nc$', dataset_refs, value = TRUE)

      dataset_list <-
        sub('.*allDatasetScan/', '', dataset_refs)

      message('  found: ', length(dataset_list), ' datasets')

      names(dataset_list) <- basename(dataset_list)

      dataset_list <- as.list(dataset_list)

    }

    return(dataset_list)

  }

  if (length(catalog_refs) > 0){

    if (.test){
      if (length(catalog_refs) > 1) {
        catalog_refs <- catalog_refs[1:2]
      }
    }

    for(catalog_ref in catalog_refs){

      new_url <- sub(basename(url), catalog_ref, url)

      link_name = sub(paste0('[/]{0,}', basename(url)), '', catalog_ref)

      result[[link_name]] <- get_dataset_links(new_url)

    }
  }

  result
}


#' Extract attributes from dataset nodes
#'
#' @param xml_nodeset an xml_nodeset
dataset_nodeset_to_df <- function(xml_nodeset){

  xml_chr_list <-
    xml_nodeset |>
    xml2::xml_attrs()

  # First link is the top level directory, not the objects we want
  xml_chr_list <- xml_chr_list[-1]

  column_names <- names(xml_chr_list[[1]])

  do.call(rbind.data.frame(), xml_chr_list) |>
    stats::setNames(column_names)
}

#' Dataset access types
#' @export
ccia_access_types <-
  list(
    OPENDAP = 'OPENDAP',
    HTTPServer = 'HTTPServer',
    WMS = 'WMS',
    WCS = 'WCS',
    NetcdfSubset = 'NetcdfSubset',
    NCML = 'NCML',
    UDDC = 'UDDC',
    ISO = 'ISO')





