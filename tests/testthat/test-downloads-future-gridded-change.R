test_that("projected_change_data/Drought work", {

  data_urls <- ccia_dataset_urls()

  # freq-duration
  url <- data_urls$projected_change_data$Drought$`freq-duration`$`spi_Amon_ACCESS1-0_rcp45_r1i1p1_anntot-events_native.nc`

  req_query <-
    url |>
    ccia_create_dataset_request_url(access_type = ccia_access_types$NetcdfSubset) |>
    ccia_add_netcdf_subset_query(vars = 'all',
                            bbox = c(154, -34, 155, -33))

  temp_file_nc <- tempfile(fileext = '.nc')

  req_filepath <-
    req_query |>
    ccia_perform_query(destfile = temp_file_nc)

  expect_true(file.exists(req_filepath))

  # time-in-drought
  url <- data_urls$projected_change_data$Drought$`time-in-drought`$`spi_Amon_ACCESS1-0_rcp45_r1i1p1_anntot-percent-in-drought_native.nc`

  req_query <-
    url |>
    ccia_create_dataset_request_url(access_type = ccia_access_types$NetcdfSubset) |>
    ccia_add_netcdf_subset_query(vars = 'all',
                                 bbox = c(154, -34, 155, -33))

  temp_file_nc <- tempfile(fileext = '.nc')

  req_filepath <-
    req_query |>
    ccia_perform_query(destfile = temp_file_nc)

  expect_true(file.exists(req_filepath))

})

test_that("projected_change_data/Evapotranspiration work", {

  data_urls <- ccia_dataset_urls()

  url <- data_urls$projected_change_data$Evapotranspiration$`2011-2030`$`wvap-morton_Amon_ACCESS1-0_rcp45_r1i1p1_2011-2030-perc-change-wrt-1986-2005-seassum-clim_native.nc`

  req_query <-
    url |>
    ccia_create_dataset_request_url(access_type = ccia_access_types$NetcdfSubset) |>
    ccia_add_netcdf_subset_query(vars = 'all',
                                 bbox = c(154, -34, 155, -33))

  temp_file_nc <- tempfile(fileext = '.nc')

  req_filepath <-
    req_query |>
    ccia_perform_query(destfile = temp_file_nc)

  expect_true(file.exists(req_filepath))

})

test_that("projected_change_data/Humidity work", {

  data_urls <- ccia_dataset_urls()

  url <- data_urls$projected_change_data$Humidity$`2015-2034`$`hurs_Amon_ACCESS1-0_rcp45_r1i1p1_2015-2034-perc-change-wrt-1986-2005-seasavg-clim_native.nc`

  req_query <-
    url |>
    ccia_create_dataset_request_url(access_type = ccia_access_types$NetcdfSubset) |>
    ccia_add_netcdf_subset_query(vars = 'all',
                                 bbox = c(154, -34, 155, -33))

  temp_file_nc <- tempfile(fileext = '.nc')

  req_filepath <-
    req_query |>
    ccia_perform_query(destfile = temp_file_nc)

  expect_true(file.exists(req_filepath))

})

test_that("projected_change_data/Maximum_Temperature work", {

  data_urls <- ccia_dataset_urls()

  url <- data_urls$projected_change_data$Maximum_Temperature$`2015-2034`$`tasmax_Amon_ACCESS1-0_rcp45_r1i1p1_2015-2034-abs-change-wrt-1986-2005-seasavg-clim_native.nc`

  req_query <-
    url |>
    ccia_create_dataset_request_url(access_type = ccia_access_types$NetcdfSubset) |>
    ccia_add_netcdf_subset_query(vars = 'all',
                                 bbox = c(154, -34, 155, -33))

  temp_file_nc <- tempfile(fileext = '.nc')

  req_filepath <-
    req_query |>
    ccia_perform_query(destfile = temp_file_nc)

  expect_true(file.exists(req_filepath))


})
