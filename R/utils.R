skip_if_no_key <- function(sys = "WMATA_KEY") {
  key <- wmata_key()
  if (!nzchar(key)) {
    testthat::skip("No API key found")
  } else {
    invisible(key)
  }
}

api_time <- function(x) {
  out <- as.POSIXct(x, format = "%Y-%m-%dT%H:%M:%S", tz = "EST")
  attr(out, "tzone") <- "UTC"
  out
}

merge2 <- function (x, y, ...) {
  out <- merge(x, y, sort = FALSE, ...)[, union(names(x), names(y))]
  tibble::as_tibble(out)
}

rows_bind <- function(list, list_names, col_name = "rowname", ...) {
  if (is.null(names(list)) && !missing(list_names)) {
    names(list) <- list_names
  }
  out <- do.call(what = "rbind", args = list, ...)
  if (!is.null(names(list))) {
    out[[col_name]] <- gsub("\\.\\d+$", "", rownames(out))
    rownames(out) <- NULL
    out[, c(ncol(out), seq(ncol(out) - 1))]
  } else {
    out
  }
}
