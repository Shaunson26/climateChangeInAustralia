test_that("application_ready_threshold/Maximum_Temperature/mon work", {

  data_urls <- ccia_dataset_urls()

  url <- data_urls$application_ready_threshold$Maximum_Temperature$`2016-2045`$mon$`tasmax_aus_NorESM1-M_rcp85_r1i1p1_CSIRO-MnCh-wrt-1986-2005-Scl_v1_mon_2016-2045.nc`

  req_query <-
    url |>
    ccia_create_dataset_request_url(access_type = ccia_access_types$NetcdfSubset) |>
    ccia_add_netcdf_subset_query(vars = 'all',
                                 bbox = c(151, -33.4, 151.1, -33.3),
                                 datetime_start = '2016-01-16',
                                 datetime_end = '2017-01-01',
                                 datetime_step = 1)

  req_filepath <-
    req_query |>
    ccia_perform_query(destfile = tempfile(fileext = '.nc'))

  expect_true(file.exists(req_filepath))

  #req_filepath |> stars::read_ncdf()

})

test_that("application_ready_threshold/Minimum_Temperature/mon work", {

  data_urls <- ccia_dataset_urls()

  url <- data_urls$application_ready_threshold$Minimum_Temperature$`2036-2065`$mon$`tasmin_aus_NorESM1-M_rcp85_r1i1p1_CSIRO-MnCh-wrt-1986-2005-Scl_v1_mon_2036-2065.nc`

  req_query <-
    url |>
    ccia_create_dataset_request_url(access_type = ccia_access_types$NetcdfSubset) |>
    ccia_add_netcdf_subset_query(vars = 'all',
                                 bbox = c(151, -33.4, 151.1, -33.3),
                                 datetime_start = '2036-01-16',
                                 datetime_end = '2036-03-17',
                                 datetime_step = 1)

  req_filepath <-
    req_query |>
    ccia_perform_query(destfile = tempfile(fileext = '.nc'))

  expect_true(file.exists(req_filepath))

  #req_filepath |> stars::read_ncdf()

})
