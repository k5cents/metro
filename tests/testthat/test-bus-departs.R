test_that("bus stop schedule for single stop", {
  skip_if_no_key()
  Sys.sleep(0.11)
  d <- bus_departs(5004768)
  expect_length(s, 7)
  expect_s3_class(d, "data.frame")
  expect_s3_class(d$ScheduleTime, "POSIXct")
})
