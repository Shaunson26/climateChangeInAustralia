#' Perform a request from a built CCIA query
#'
#' @param request httr2 request with query parameters
#' @param destfile where the response body should be written
#'
#' @return filepath character vector
#'
#' @export
ccia_perform_query <- function(request, destfile){

  has_query <- grepl('?', request$url, fixed = TRUE)

  stopifnot('request does not seem to have a query attached' = has_query)

  resp <-
    request |>
    httr2::req_error(is_error = function(resp) FALSE) |>
    httr2::req_perform()

  if (httr2::resp_status(resp) == 400){

    server_message <-
      resp |>
      httr2::resp_body_string()

    stop('\nResponse from server:\n  ', server_message)

  }

  if (httr2::resp_status(resp) != 200){

    server_message <-
      resp |>
      httr2::resp_body_string()

    stop('\nResponse from server:\n  ', server_message)

  }

  if (httr2::resp_status(resp) == 200) {

    resp |>
      httr2::resp_body_raw() |>
      writeBin(con = destfile)

  }

  if (file.exists(destfile)){
    message('file downloaded to: ', destfile)
    return(destfile)
  }
}
