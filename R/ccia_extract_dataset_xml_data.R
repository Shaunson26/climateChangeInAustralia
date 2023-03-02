#' Extract variable and timespan data from data description XML
#'
#' Extract `grid` and `TimeSpan` elements from data description XML into a list
#'
#' @param xml xml2::xml_document
#'
#' @return a list
ccia_extract_dataset_xml_data <- function(xml){

  output <- list()

  output$vars <-
    xml |>
    xml2::xml_find_all("//grid") |>
    xml2::xml_attrs() |>
    purrr::map_df(.f = dplyr::bind_rows)

  output$TimeSpan <-
    xml |>
    xml2::xml_find_all("//TimeSpan") |>
    xml2::xml_children() |>
    xml2::xml_text() |>
    as.list()

  names(output$TimeSpan) <-
    xml |>
    xml2::xml_find_all("//TimeSpan") |>
    xml2::xml_children() |>
    xml2::xml_name()

  output
}
