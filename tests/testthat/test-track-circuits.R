test_that("all train circuits are returned", {
  skip_if_no_key()
  Sys.sleep(0.11)
  c <- track_circuits()
  expect_s3_class(c, "data.frame")
  expect_length(c, 3)
  expect_type(c$Neighbors, "list")
  expect_type(c$Neighbors[[1]]$CircuitIds, "list")
})
