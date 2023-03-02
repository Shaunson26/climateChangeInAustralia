test_that("format_datatime works", {

  test_values <-
    list(
      a_charater_date = '2023-01-01',
      a_charactet_time = '2023-01-01 12:00:00',
      a_date = as.Date('2023-01-01'),
      a_time_ct = as.POSIXct('2023-01-01 12:00:00'),
      a_time_lt = as.POSIXlt('2023-01-01 12:00:00'),
      a_datetime_not_to_change = '2030-01-01T12:00:00Z'
    )

  result_values <- lapply(test_values, format_datetime)

  expected_values <-
    list(
      a_charater_date = "2023-01-01T00:00:00Z",
      a_charactet_time =  "2023-01-01T12:00:00Z",
      a_date = "2023-01-01T00:00:00Z",
      a_time_ct = "2023-01-01T12:00:00Z",
      a_time_lt = "2023-01-01T12:00:00Z",
      a_datetime_not_to_change = "2030-01-01T12:00:00Z"
    )

  expect_identical(result_values, expected_values)
})

