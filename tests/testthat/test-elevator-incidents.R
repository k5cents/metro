test_that("all elevator outages returned", {
  i <- elevator_incidents(station = NULL)
  expect_length(i, 9)
  expect_s3_class(i, "data.frame")
  expect_s3_class(i$date_broken, "POSIXlt")
})
