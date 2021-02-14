#' Metro rail stations
#'
#' The stations on a Metro rail line, including the full names and geographic
#' locations. The four big transfer stations have two station code designations,
#' one for each track direction. All the lines running through each station
#' are listed in a single list-column.
#'
#' @details
#' The `line_code` takes one of these two-letter codes:
#' * BL = Blue
#' * GR = Green
#' * OR = Orange
#' * RD = Red
#' * SV = Silver
#' * YL = Yellow
#'
#' The result of this endpoint is saved as the [metro_stations] object.
#' @param line Two-letter line code abbreviation, see Details or [rail_lines()].
#'   If `NULL`, (the default) all stations are returned.
#' @importFrom jsonlite fromJSON
#' @importFrom tibble as_tibble add_column
#' @export
rail_stations <- function(line = NULL) {
  json <- wmata_api("Rail", "jStations", list(LineCode = line))
  df <- jsonlite::fromJSON(json, flatten = TRUE)
  df <- utils::type.convert(
    x = df$Stations[, c(-4, -8)],
    na.strings = "",
    as.is = TRUE
  )
  l <- Map(paste, df[4], df[5], df[6])
  l <- strsplit(gsub("\\s?NA\\s?", "", l[[1]]), "\\s")
  df <- tibble::add_column(df[, -(4:6)], lines = l, .after = 3)
  nm <- names(df)
  nm[c(1, 3)] <- c("station", "txfer")
  names(df) <- gsub("address\\.", "", tolower(nm))
  tibble::as_tibble(df)
}
