test_that("all train circuits are returned", {
  skip_if_no_key()
  Sys.sleep(0.11)
  r <- standard_routes()
  expect_s3_class(r, "data.frame")
  expect_length(r, 3)
  expect_type(r$TrackCircuits, "list")
  expect_type(r$TrackCircuits[[1]]$SeqNum, "integer")
})
