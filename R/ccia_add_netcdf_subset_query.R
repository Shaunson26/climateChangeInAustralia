#' Add query parameters of CCIA NetCDF Subset Service to a request URL
#'
#' Add query parameters to a CCIA request URL. Note that returned data is dependent
#' on what is available and might not exactly match the request e.g. where the time
#' slices are centered monthly or yearly.
#'
#' @param request httr2 request
#' @param vars dataset variables to download. Use 'all' for all available.
#' @param lat, number, latitude
#' @param lon number, longitude
#' @param bbox number, vector of length 4: left,bottom,right,top | min Longitude , min Latitude , max Longitude , max Latitude
#' @param datetime_start date, can be character, Date or POSIX*
#' @param datetime_end date, can be character, Date or POSIX*
#' @param datetime_step number, days between date_start and date_end to download
#'
#' @return character, path to temporary file that is downloaded
#'
#' @export
ccia_add_netcdf_subset_query <- function(request, vars, bbox, lat, lon, datetime_start, datetime_end, datetime_step){

  # check inputs
  if (!missing(bbox) & any(!missing(lat), !missing(lon))){
    stop('only one of bbox or lat/lon can be given')
  }

  if (!missing(bbox)){
    if (length(bbox) != 4) {
      stop('bbox should be a number vector of length 4: left,bottom,right,top | min Longitude , min Latitude , max Longitude , max Latitude')
    }
  }

  # Build query list elements

  ## Vars ----

  vars <-
    as.list(vars)

  names(vars) <- rep('var', length(vars))

  ## Coords / BBox ----

  if (missing(bbox)){
    bbox <-
      c(west = lon - 0.0001,
        south = lat - 0.0001,
        east = lon + 0.0001,
        north = lat + 0.0001
      )
  }

  names(bbox) <- c('west', 'south', 'east', 'north')

  bbox <-
    as.list(bbox)

  check_bbox(bbox)

  # match order of NCSS Request URL builder
  bbox <- bbox[c('north', 'west', 'east', 'south')]

  ## Times ----
  times <- list()

  times_urls <-
    c('Projected_Change_Data/Drought/freq-duration' = FALSE,
      'Projected_Change_Data/Drought/time-in-drought' = FALSE,
      'Projected_Change_Data/Evapotranspiration' = FALSE,
      'Projected_Change_Data/Humidity' = FALSE,
      'Projected_Change_Data/Maximum_Temperature' = FALSE,
      'Projected_Change_Data/Mean_Temperature' = TRUE,
      #
      'Application_Ready_Data_Gridded_Aggregates/Mean_Temperature' = FALSE,
      'Application_Ready_Data_Gridded_Thresholds' = TRUE)

  times_urls <- paste(names(times_urls)[times_urls], collapse = "|")

  needs_times <- grepl(times_urls, request$url)

  if (needs_times){
    times <-
      list(
        time_start = format_datetime(datetime_start),
        time_end = format_datetime(datetime_end),
        timeStride = datetime_step
      )
  }

  ## Accept format ----

  accept = list()

  accept_urls <-
    c('Projected_Change_Data' = FALSE,
      'Application_Ready_Data' = TRUE)

  accept_urls <- paste(names(accept_urls)[accept_urls], collapse = "|")

  needs_accept <- grepl(accept_urls, request$url)

  if (needs_accept){
    accept <-
      list(
        accept='netcdf4'
      )
  }

  # Finalise query
  query <-
    c(vars,
      bbox,
      times,
      disableProjSubset='on',
      horizStride = 1,
      accept
    )

  request |>
    httr2::req_headers(Accept = "application/x-netcdf4") |>
    httr2::req_url_query(!!!query)
}

