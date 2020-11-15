test_that("API errors for a bad path", {
  expect_error(wmata_api(path = ""))
})

test_that("API returns JSON for a proper path", {
  skip_if_no_key()
  Sys.sleep(0.5)
  x <- wmata_api("/Rail.svc/json/jLines")
  expect_length(x, 1)
})
