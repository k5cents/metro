is_installed <- function(pkg) {
  isTRUE(requireNamespace(pkg, quietly = TRUE))
}
