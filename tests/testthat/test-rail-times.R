test_that("all station times returned when NULL", {
  skip_if_no_key()
  Sys.sleep(0.11)
  x <- rail_times()
  expect_gte(length(unique(x$StationCode)), 1)
  expect_length(x, 7)
  expect_s3_class(x, "data.frame")
  expect_s3_class(x$OpeningTime, "hms")
})

test_that("station times returned as hour character", {
  skip_if_no_key()
  Sys.sleep(0.11)
  x <- rail_times("A01")
  expect_length(x, 7)
  expect_s3_class(x, "data.frame")
  expect_s3_class(x$OpeningTime, "hms")
})
