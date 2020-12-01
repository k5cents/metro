test_that("next bus returned for single stop", {
  skip_if_no_key()
  Sys.sleep(0.11)
  n <- next_bus(stop = 2000474)
  expect_s3_class(n, "data.frame")
  expect_length(n, 6)
})
