is_installed <- function(pkg) {
  isTRUE(requireNamespace(pkg, quietly = TRUE))
}

as_tibble <- function(x) {
  if (is_installed("tibble")) {
    tibble::as_tibble(x)
  } else {
    x
  }
}

skip_if_no_key <- function(sys = "WMATA_KEY") {
  key <- Sys.getenv(sys)
  if (!nzchar(key) && is_installed("rvest")) {
    key <- wmata_demo()
  }
  if (!nzchar(key)) {
    skip("No API key found")
  } else {
    Sys.setenv("WMATA_KEY" = key)
  }
}
