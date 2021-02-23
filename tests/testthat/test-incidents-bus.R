test_that("all bus incidents returned", {
  skip_if_no_key()
  Sys.sleep(0.11)
  i <- bus_incidents()
  expect_length(i, 5)
  expect_s3_class(i, "data.frame")
  expect_s3_class(i$DateUpdated, "POSIXct")
})
