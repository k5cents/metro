#' Rail incidents
#'
#' Returns reported rail incidents (significant disruptions and delays to normal
#' service). The data is identical to WMATA's Metrorail Service Status feed.
#'
#' @export
rail_incidents <- function() {
  json <- wmata_api(type = "Incidents", endpoint = "Incidents")
  df <- jsonlite::fromJSON(json, flatten = TRUE)[[1]]
  if (length(df) == 0) {
    message("no rail incidents reported")
    return(empty_incidents)
  }
  df <- df[, c(1, 7, 9, 10, 2)]
  names(df) <- names(empty_incidents)
  df[[3]] <- strsplit(df[[3]], ";")
  if (all(vapply(df[[3]], length, double(1)) == 1)) {
    df[[3]] <- unlist(df[[3]])
  }
  df[[4]] <- api_time(df[[4]])
  tibble::as_tibble(df)
}

empty_incidents <- data.frame(
  incident = character(),
  type = character(),
  lines = character(),
  updated = as.Date(character()),
  description = character()
)
