#' Check a given bounding box list values are correct
#'
#' Ensure the bbox values are in the correct order
#'
#' @param x a list with 4 named elements
#'
#' @return nothing
check_bbox <- function(x){

    valid_bbox <- x$west < x$east &
    x$south < x$north

  stopifnot(valid_bbox)

  invisible(NULL)
}


#' Format a datetime for a NetCDF query
#'
#' @param x a character, or datetime (Date, as.POSIX*)
#'
#' @return formatted character value
format_datetime <- function(x){

  input_is_as_output <- grepl('.*T.*Z', x)

  if (input_is_as_output){
    return(x)
  }

  if (inherits(x, 'character')){
    x <- as.POSIXct(x)
  }

  format(x, '%FT%TZ')
}

#' text finder
#'
#' Find text in function bodies
#'
#' @param x text to find
find_text <- function(x){
  zz <- list.files('R/', full.names = TRUE)

  mm <- sapply(zz, function(file){
    filelines <- readLines(file)
    any(grepl(x, filelines))
  })

  zz[mm]

}





