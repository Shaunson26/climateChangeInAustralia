test_that("extraction works", {

  xml_example_path <- system.file(package = 'climateChangeInAustralia', 'dataset-example.xml')

  result <-
    xml2::read_xml(xml_example_path) |>
    ccia_extract_dataset_xml_data()

  expect_identical(names(result), c('vars', 'TimeSpan'))
  expect_identical(names(result$TimeSpan), c('begin', 'end'))
})
