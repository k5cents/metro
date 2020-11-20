test_that("bus stop schedule for single stop", {
  s <- bus_departs(5004768)
  expect_length(s, 7)
  expect_s3_class(s, "data.frame")
  expect_s3_class(s$depart_time, "POSIXlt")
})
