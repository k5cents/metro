test_that("stations info is listed for multiple stations", {
  skip_if_no_key()
  Sys.sleep(0.11)
  s <- station_info(StationCode = c("A07", "B07"))
  expect_length(s, 10)
  expect_equal(nrow(s), 2)
  expect_s3_class(s, "data.frame")
  expect_type(s$LineCodes, "list")
  expect_gt(length(unique(s$Code)), 1)
})

test_that("station info fails for more than 9", {
  expect_error(station_info(StationCode = metro_stations[1:10]))
})
