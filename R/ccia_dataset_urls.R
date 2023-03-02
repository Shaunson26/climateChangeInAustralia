#' Read the Climate Change Australian URL JSON
#'
#' Return a list of the URLs
#'
#' @return a list
#' @export
ccia_dataset_urls <- function(){

  dataset_json <- system.file(package = 'climateChangeInAustralia', 'dataset-urls.json')

  dataset_list <- jsonlite::fromJSON(dataset_json)
  class(dataset_list) <- c('ccia_list', class(dataset_list))

  class_apply(dataset_list)

}

class_apply <- function(x, class = c('ccia_list', 'list')){

  class(x) <- class
  x_names <- names(x)
  has_dataset_names <- any(grepl('nc$', x_names))

  if (has_dataset_names){
    return(x)
  }

  for(i in seq_along(x_names)){
    x[[i]] <- class_apply(x[[i]], class)
  }

  x
}

#' @export
print.ccia_list <- function(x, indent = 0, ...){


    x_names <- names(x)
    has_dataset_names <- any(grepl('nc$', x_names))

    indent = indent + 1
    indent_chars <- paste(rep('-', times = indent), collapse = '')

    if (has_dataset_names){
      cat(paste(indent_chars, length(x_names), 'dataset URLs'), sep = "\n")
      return(invisible(NULL))
    }

    for(i in seq_along(x_names)){
      cat(paste(indent_chars, x_names[i]), sep = "\n")
      print.ccia_list(x[[i]], indent)
    }


}


