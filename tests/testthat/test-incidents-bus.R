test_that("all bus incidents returned", {
  skip_if_no_key()
  Sys.sleep(0.11)
  i <- bus_incidents()
  expect_length(i, 5)
  expect_s3_class(i, "data.frame")
  expect_s3_class(i$DateUpdated, "POSIXct")
})

test_that("empty tibble returned without bus incidents", {
  skip_if_no_key()
  Sys.sleep(0.11)
  i <- mockr::with_mock(
    .env = as.environment("package:metro"),
    `no_data_now` = function(x) TRUE,
    expect_message(bus_incidents())
  )
  expect_equal(nrow(i), 0)
  expect_s3_class(i, "data.frame")
})
