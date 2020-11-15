is_installed <- function(pkg) {
  isTRUE(requireNamespace(pkg, quietly = TRUE))
}

skip_if_no_key <- function(sys = "WMATA_KEY") {
  key <- Sys.getenv(sys)
  if (!nzchar(key) && is_installed("rvest")) {
    key <- wmata_demo()
  }
  if (!nzchar(key)) {
    testthat::skip("No API key found")
  } else {
    Sys.setenv("WMATA_KEY" = key)
  }
}
