test_that("all elevator outages returned", {
  skip_if_no_key()
  Sys.sleep(0.11)
  i <- elevator_incidents(StationCode = NULL)
  expect_length(i, 9)
  expect_s3_class(i, "data.frame")
  expect_s3_class(i$DateOutOfServ, "POSIXct")
})

test_that("empty tibble returned without elevator incidents", {
  skip_if_no_key()
  Sys.sleep(0.11)
  i <- mockr::with_mock(
    .env = as.environment("package:metro"),
    `no_data_now` = function(x) TRUE,
    {
      expect_message(elevator_incidents(StationCode = NULL))
    }
  )
  expect_equal(nrow(i), 0)
  expect_s3_class(i, "data.frame")
})
