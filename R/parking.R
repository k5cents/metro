#' Parking information at Metro stations
#'
#' @param line Two-letter line code abbreviation, see [lines] or [rail_lines()].
#' @importFrom jsonlite fromJSON
#' @importFrom tibble as_tibble
#' @importFrom utils type.convert
#' @export
parking_spots <- function(line = NULL) {
  json <- wmata_api("Rail.svc/json/jStationParking", list(LineCode = line))
  df <- jsonlite::fromJSON(json, flatten = TRUE)
  df <- type.convert(df$StationsParking, na.strings = "", as.is = TRUE)
  out <- rbind(
    data.frame(station = df$Code, all_day = TRUE, spots = df[[3]]),
    data.frame(station = df$Code, all_day = FALSE, spots = df[[8]])
  )
  tibble::as_tibble(out[order(out$station), ])
}

#' @rdname parking_spots
#' @importFrom jsonlite fromJSON
#' @importFrom tibble as_tibble
#' @importFrom utils type.convert
#' @export
parking_cost <- function(line = NULL) {
  json <- wmata_api("Rail.svc/json/jStationParking", list(LineCode = line))
  df <- jsonlite::fromJSON(json, flatten = TRUE)
  df <- type.convert(df$StationsParking, na.strings = "", as.is = TRUE)
  all_day <- data.frame(
    station = rep(df$Code, each = 3),
    type = rep(c("regrider", "nonrider", "saturday"), length = 3),
    cost = c(df[[4]], df[[5]], df[[6]]),
    stringsAsFactors = FALSE
  )
  tibble::as_tibble(all_day[!is.na(all_day$cost), ])
}
