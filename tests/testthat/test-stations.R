Sys.sleep(1)
test_that("rail stations are listed for all lines", {
  s <- rail_stations(line = NULL)
  expect_length(s, 10)
  expect_equal(nrow(s), 95)
  expect_s3_class(s, "data.frame")
  expect_type(s$lines, "list")
})

Sys.sleep(1)
test_that("rail stations are listed for one", {
  s <- rail_stations(line = "RD")
  expect_length(s, 10)
  expect_equal(nrow(s), 27)
  expect_s3_class(s, "data.frame")
  expect_type(s$lines, "list")
})
