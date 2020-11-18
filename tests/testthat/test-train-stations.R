test_that("rail stations are listed for all lines", {
  skip_if_no_key()
  Sys.sleep(0.1)
  s <- rail_stations(line = NULL)
  expect_length(s, 10)
  expect_equal(nrow(s), 95)
  expect_s3_class(s, "data.frame")
  expect_type(s$lines, "list")
})

test_that("rail stations are listed for one", {
  skip_if_no_key()
  Sys.sleep(0.1)
  s <- rail_stations(line = "RD")
  expect_length(s, 10)
  expect_equal(nrow(s), 27)
  expect_s3_class(s, "data.frame")
  expect_type(s$lines, "list")
})
