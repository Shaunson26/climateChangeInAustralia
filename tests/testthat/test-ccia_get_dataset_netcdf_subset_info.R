test_that("ccia_get_dataset_netcdf_subset_info works", {

  ccia_datasets <- ccia_dataset_urls()

  ara_mean_temp_2016_access1_rcp45 <-
    ccia_datasets$
    application_ready_aggregated$
    Mean_Temperature$
    `2016-2045`$
    `tas_aus_ACCESS1-0_rcp45_r1i1p1_CSIRO-MnCh-wrt-1986-2005-Scl_v1_mon_seasavg_2016-2045_clim.nc`

  ara_mean_temp_2016_access1_rcp45_info <-
    ara_mean_temp_2016_access1_rcp45 |>
    ccia_create_dataset_request_url(access_type = ccia_access_types$NetcdfSubset) |>
    ccia_get_dataset_netcdf_subset_info()


  expect_identical(names(ara_mean_temp_2016_access1_rcp45_info), c('vars', 'TimeSpan'))
  expect_identical(names(ara_mean_temp_2016_access1_rcp45_info$TimeSpan), c('begin', 'end'))
})
