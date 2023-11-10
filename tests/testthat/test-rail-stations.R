test_that("rail stations are listed for all lines", {
  skip_if_no_key()
  Sys.sleep(0.11)
  s <- rail_stations(LineCode = NULL)
  expect_length(s, 10)
  expect_equal(nrow(s), 102)
  expect_s3_class(s, "data.frame")
  expect_type(s$LineCodes, "list")
})

test_that("rail stations are listed for one line", {
  skip_if_no_key()
  Sys.sleep(0.11)
  s <- rail_stations(LineCode = "RD")
  expect_length(s, 10)
  expect_equal(nrow(s), 27)
  expect_s3_class(s, "data.frame")
  expect_type(s$LineCodes, "list")
})
