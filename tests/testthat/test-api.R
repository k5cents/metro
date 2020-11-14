skip_if_no_key <- function(sys = "WMATA_KEY") {
  skip_if_not(nzchar(Sys.getenv(sys)))
}

test_that("API errors for a bad path", {
  expect_error(wmata_api(path = ""))
})

test_that("API returns JSON for a proper path", {
  skip_if_no_key()
  x <- wmata_api("/Rail.svc/json/jLines")
  expect_length(x, 1)
})
