test_that("projected_change_data urls", {

  datasets <- ccia_dataset_urls()

  url <- datasets$projected_change_data$Mean_Temperature$`2020-2039`$`tas_Amon_ACCESS1-0_rcp45_r1i1p1_2020-2039-abs-change-wrt-1986-2005-seasavg-clim_native.nc`

  # Netcdf
  request <- ccia_create_dataset_request_url(url, access_type = ccia_access_types$NetcdfSubset)

  expect_s3_class(request, class = 'httr2_request')

  expected_url <- 'https://dapds00.nci.org.au/thredds/ncss/ua6_4/CMIP5/derived/Collections/Projected_Change_Data/Mean_Temperature/2020-2039/tas_Amon_ACCESS1-0_rcp45_r1i1p1_2020-2039-abs-change-wrt-1986-2005-seasavg-clim_native.nc'

  expect_equal(request$url, expected = expected_url)

  # OPENDAP
  request <- ccia_create_dataset_request_url(url, access_type = ccia_access_types$OPENDAP)

  expect_s3_class(request, class = 'httr2_request')

  expected_url <- 'https://dapds00.nci.org.au/thredds/dods/ua6_4/CMIP5/derived/Collections/Projected_Change_Data/Mean_Temperature/2020-2039/tas_Amon_ACCESS1-0_rcp45_r1i1p1_2020-2039-abs-change-wrt-1986-2005-seasavg-clim_native.nc'

  expect_equal(request$url, expected = expected_url)
})

test_that("application_ready_daily urls", {

  datasets <- ccia_dataset_urls()

  url <- datasets$application_ready_daily$Mean_Temperature$`2016-2045`$`tas_aus_ACCESS1-0_rcp45_r1i1p1_CSIRO-MnCh-wrt-1986-2005-Scl_v1_day_2016-2045.nc`

  request <- ccia_create_dataset_request_url(url, access_type = ccia_access_types$NetcdfSubset)

  expect_s3_class(request, class = 'httr2_request')

  expected_url <-
    'https://data-cbr.csiro.au/thredds/ncss/catch_all/oa-aus5km/Climate_Change_in_Australia_User_Data/Application_Ready_Data_Gridded_Daily/Mean_Temperature/2016-2045/tas_aus_ACCESS1-0_rcp45_r1i1p1_CSIRO-MnCh-wrt-1986-2005-Scl_v1_day_2016-2045.nc'

  expect_equal(request$url, expected = expected_url)
})

test_that("application_ready_aggregated urls", {

  datasets <- ccia_dataset_urls()

  url <- datasets$application_ready_aggregated$Mean_Temperature$`2056-2085`$`tas_aus_NorESM1-M_rcp85_r1i1p1_CSIRO-MnCh-wrt-1986-2005-Scl_v1_mon_seasavg_2056-2085_clim.nc`

  request <- ccia_create_dataset_request_url(url, access_type = ccia_access_types$NetcdfSubset)

  expect_s3_class(request, class = 'httr2_request')

  expected_url <-
    'https://data-cbr.csiro.au/thredds/ncss/catch_all/oa-aus5km/Climate_Change_in_Australia_User_Data/Application_Ready_Data_Gridded_Aggregates/Mean_Temperature/2056-2085/tas_aus_NorESM1-M_rcp85_r1i1p1_CSIRO-MnCh-wrt-1986-2005-Scl_v1_mon_seasavg_2056-2085_clim.nc'

  expect_equal(request$url, expected = expected_url)
})

test_that("application_ready_threshold urls", {

  datasets <- ccia_dataset_urls()

  url <- datasets$application_ready_threshold$Minimum_Temperature$`2075-2104`$mon$`tasmin_aus_NorESM1-M_rcp85_r1i1p1_CSIRO-MnCh-wrt-1986-2005-Scl_v1_mon_2075-2104.nc`

  request <- ccia_create_dataset_request_url(url, access_type = ccia_access_types$NetcdfSubset)

  expect_s3_class(request, class = 'httr2_request')

  expected_url <-
    'https://data-cbr.csiro.au/thredds/ncss/catch_all/oa-aus5km/Climate_Change_in_Australia_User_Data/Application_Ready_Data_Gridded_Thresholds/Minimum_Temperature/2075-2104/mon/tasmin_aus_NorESM1-M_rcp85_r1i1p1_CSIRO-MnCh-wrt-1986-2005-Scl_v1_mon_2075-2104.nc'

  expect_equal(request$url, expected = expected_url)
})


