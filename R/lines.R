#' Metro rail lines
#'
#' The result of this endpoint is saved as the [lines] object.
#'
#' @export
rail_lines <- function() {
  json <- wmata_api("Rail.svc/json/jLines")
  df <- jsonlite::fromJSON(json)
  df <- type.convert(df$Lines[, 1:4], na.strings = "", as.is = TRUE)
  names(df) <- c("line", "name", "start", "end")
  tibble::as_tibble(df)
}
