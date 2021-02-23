test_that("bus schedule returns for both directions", {
  skip_if_no_key()
  Sys.sleep(0.11)
  s <- bus_schedule("10A")
  expect_length(s, 10)
  expect_s3_class(s, "data.frame")
  expect_s3_class(s$EndTime, "POSIXct")
})
