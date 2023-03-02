test_that("application_ready_aggregated/Mean_Temperature work", {

  data_urls <- ccia_dataset_urls()

  url <- data_urls$application_ready_aggregated$Mean_Temperature$`2016-2045`$`tas_aus_ACCESS1-0_rcp45_r1i1p1_CSIRO-MnCh-wrt-1986-2005-Scl_v1_mon_seasavg_2016-2045_clim.nc`

  req_query <-
    url |>
    ccia_create_dataset_request_url(access_type = ccia_access_types$NetcdfSubset) |>
    ccia_add_netcdf_subset_query(vars = c('tas_annual', 'tas_april'),
                                 bbox = c(151, -33.4, 151.1, -33.3),
                                 # these are ignored
                                 datetime_start = '2021-01-01',
                                 datetime_end = '2021-01-31',
                                 datetime_step = 2)

  temp_file_nc <- tempfile(fileext = '.nc')

  req_filepath <-
    req_query |>
    ccia_perform_query(destfile = temp_file_nc)

  expect_true(file.exists(req_filepath))

  #temp_file_nc |> stars::read_ncdf()

})

test_that("application_ready_aggregated/Mean_Temperature work", {

  data_urls <- ccia_dataset_urls()

  url <-
    data_urls$application_ready_aggregated$`Rainfall_(Precipitation)`$`2075-2104`$`pr_aus_HadGEM2-CC_rcp45_r1i1p1_CSIRO-MnCh-wrt-1986-2005-Scl_v1_mon_seasavg_2075-2104_clim.nc`

  req_query <-
    url |>
    ccia_create_dataset_request_url(access_type = ccia_access_types$NetcdfSubset) |>
    ccia_add_netcdf_subset_query(vars = c('pr_annual', 'pr_april'),
                                 bbox = c(151, -33.4, 151.1, -33.3),
                                 # these are ignored
                                 datetime_start = '2090-01-01',
                                 datetime_end = '2090-01-01',
                                 datetime_step = 1)

  temp_file_nc <- tempfile(fileext = '.nc')

  req_filepath <-
    req_query |>
    ccia_perform_query(destfile = temp_file_nc)

  expect_true(file.exists(req_filepath))

  # Error checking
  req_query <-
    url |>
    ccia_create_dataset_request_url(access_type = ccia_access_types$NetcdfSubset) |>
    # wrong variable
    ccia_add_netcdf_subset_query(vars = c('pr_annual', 'tas_april'),
                                 bbox = c(151, -33.4, 151.1, -33.3),
                                 # these are ignored
                                 datetime_start = '2090-01-01',
                                 datetime_end = '2090-01-01',
                                 datetime_step = 1)

  temp_file_nc <- tempfile(fileext = '.nc')

  expect_error(regexp = 'not contained in the requested dataset',
               ccia_perform_query(req_query, destfile = temp_file_nc))

})
