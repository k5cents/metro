test_that("all rail incidents returned", {
  i <- rail_incidents()
  expect_length(i, 5)
  expect_s3_class(i, "data.frame")
  expect_s3_class(i$updated, "POSIXlt")
})
