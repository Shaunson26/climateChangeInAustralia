test_that("check_bbox works", {

  expect_no_condition(
    check_bbox(
      list(west = 150,
           south = -34,
           east = 155,
           north = -32
      )
    )
  )

  expect_error(
    check_bbox(
      list(west = 155, # wrong
           south = -34,
           east = 150, # wrong
           north = -32
      )
    )
  )

  expect_error(
    check_bbox(
      list(west = 150,
           south = -32, # wrong
           east = 155,
           north = -34 # wrong
      )
    )
  )

})
