test_that("projected_change_data", {

  # TODO
  ccia_datasets <- ccia_dataset_urls()
  url <- ccia_datasets$projected_change_data$Drought$`freq-duration`$`spi_Amon_ACCESS1-0_rcp45_r1i1p1_anntot-events_native.nc`

  request <-
    url |>
    ccia_create_dataset_request_url(access_type = ccia_access_types$NetcdfSubset) |>
    ccia_add_netcdf_subset_query(vars = 'all',
                                 bbox = c(151, -34, 155, -32))


  expect_s3_class(request, class = 'httr2_request')
  expect_identical(request$headers$Accept, "application/x-netcdf4")

  # will break when date checking is updated
  expect_identical(
    request$url,
    'https://dapds00.nci.org.au/thredds/ncss/ua6_4/CMIP5/derived/Collections/Projected_Change_Data/Drought/freq-duration/spi_Amon_ACCESS1-0_rcp45_r1i1p1_anntot-events_native.nc?var=all&north=-32&west=151&east=155&south=-34&disableProjSubset=on&horizStride=1'
  )


})

test_that('application_ready_aggregated URL', {

  data_urls <- ccia_dataset_urls()

  url <-
    data_urls$application_ready_aggregated$`Rainfall_(Precipitation)`$`2075-2104`$`pr_aus_HadGEM2-CC_rcp45_r1i1p1_CSIRO-MnCh-wrt-1986-2005-Scl_v1_mon_seasavg_2075-2104_clim.nc`

  request <-
    url |>
    ccia_create_dataset_request_url(access_type = ccia_access_types$NetcdfSubset) |>
    ccia_add_netcdf_subset_query(vars = c('pr_annual', 'pr_april'),
                                 bbox = c(151, -33.4, 151.1, -33.3),
                                 datetime_start = '2021-01-01',
                                 datetime_end = '2021-01-31',
                                 datetime_step = 2)

  # will break when date checking is updated
  expect_identical(
    request$url,
    'https://data-cbr.csiro.au/thredds/ncss/catch_all/oa-aus5km/Climate_Change_in_Australia_User_Data/Application_Ready_Data_Gridded_Aggregates/Rainfall_(Precipitation)/2075-2104/pr_aus_HadGEM2-CC_rcp45_r1i1p1_CSIRO-MnCh-wrt-1986-2005-Scl_v1_mon_seasavg_2075-2104_clim.nc?var=pr_annual&var=pr_april&north=-33.3&west=151&east=151.1&south=-33.4&disableProjSubset=on&horizStride=1&accept=netcdf4'
  )

})

test_that("bbox vs lat/lon error is thrown", {


  expect_error(regexp = 'only one of bbox or lat/lon can be given',
               ccia_add_netcdf_subset_query(request = httr2::request('http://base.com'),
                                            vars = 'tas_annual',
                                            lat = 30, lon = 150,
                                            bbox = c(151, -33.4, 151.1, -33.3))
  )
})
