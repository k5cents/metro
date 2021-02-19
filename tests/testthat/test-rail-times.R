test_that("all station times returned when NULL", {
  skip_if_no_key()
  Sys.sleep(0.11)
  x <- rail_times()
  expect_gt(length(unique(x$station)), 1)
  expect_length(x, 6)
  expect_s3_class(x, "data.frame")
})

test_that("station times returned as datetime", {
  skip_if_no_key()
  Sys.sleep(0.11)
  x <- rail_times("A01", dates = TRUE)
  expect_length(x, 6)
  expect_s3_class(x$open, "POSIXct")
  expect_s3_class(x, "data.frame")
})

test_that("station times returned as hour character", {
  skip_if_no_key()
  Sys.sleep(0.11)
  x <- rail_times("A01", dates = FALSE)
  expect_length(x, 6)
  expect_type(x$open, "character")
  expect_equal(unique(nchar(x$open)), 5)
  expect_s3_class(x, "data.frame")
})
