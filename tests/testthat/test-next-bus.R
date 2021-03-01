test_that("next bus returned for single stop", {
  skip_if_no_key()
  Sys.sleep(0.11)
  n <- next_bus(StopID = 2000474)
  expect_s3_class(n, "data.frame")
  expect_length(n, 8)
})

test_that("empty tibble returned without next bus", {
  skip_if_no_key()
  Sys.sleep(0.11)
  n <- mockr::with_mock(
    .env = as.environment("package:metro"),
    `no_data_now` = function(x) TRUE,
    expect_message(next_bus(StopID = 2000474))
  )
  expect_equal(nrow(n), 0)
  expect_s3_class(n, "data.frame")
})
