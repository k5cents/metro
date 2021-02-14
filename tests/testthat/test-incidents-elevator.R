test_that("all elevator outages returned", {
  skip_if_no_key()
  Sys.sleep(0.11)
  i <- elevator_incidents(StationCode = NULL)
  expect_length(i, 9)
  expect_s3_class(i, "data.frame")
  expect_s3_class(i$DateOutOfServ, "POSIXct")
})
