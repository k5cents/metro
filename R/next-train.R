#' Next train
#'
#' Returns next train arrival information for one or more stations. Will return
#' an empty set of results when no predictions are available. Use `NULL` for the
#' `station` parameter to return predictions for all stations.
#'
#' For terminal stations (e.g.: Greenbelt, Shady Grove, etc.), predictions may
#' be displayed twice.
#'
#' Some stations have two platforms (e.g.: Gallery Place, Fort Totten, L'Enfant
#' Plaza, and Metro Center). To retrieve complete predictions for these
#' stations, be sure to pass in both StationCodes.
#'
#' For trains with no passengers, the DestinationName will be "No Passenger".
#' @format A tibble with 9 variables:
#' \describe{
#'   \item{order}{The order in which trains will arrive at the station.}
#'   \item{station}{Station code for where the train is arriving.}
#'   \item{name}{Full name of the station where the train is arriving.}
#'   \item{min}{Minutes until arrival: "ARR" converted to 0 and "BRD" to -1.}
#'   \item{to_station}{Abbreviated _final_ destination for a train.}
#'   \item{to_name}{Destination station code.}
#'   \item{group}{Denotes the track this train is on but not Track "1" or "2".}
#'   \item{line}{Two-letter abbreviation for the line}
#'   \item{cars}{Number of cars on a train, usually 6 or 8.}
#' }
#' @source <https://api.wmata.com/StationPrediction.svc/json/GetPrediction/>
#' @param station Character vector of station names or `NULL` for all.
#' @export
next_train <- function(station = NULL) {
  if (all(is.null(station))) {
    station <- "All"
  }
  json <- wmata_api(
    type = "StationPrediction",
    endpoint = paste("GetPrediction", paste(station, collapse = ","), sep = "/")
  )
  df <- jsonlite::fromJSON(json, flatten = TRUE)[[1]]
  if (length(df) == 1) {
    warning("no next trains at this station")
    return(empty_train)
  }
  df <- df[, c(7:9, 3:6, 1)]
  df <- tibble::add_column(df, Order = seq(nrow(df)), .before = 1)
  names(df) <- names(empty_train)
  mins <- df$min
  mins[mins == "ARR"] <- 0
  mins[mins == "BRD"] <- -1
  mins[mins == "---" | mins == ""] <- NA
  df$min <- as.integer(mins)
  df$cars[df$cars == "-"] <- NA
  df$cars <- as.integer(df$cars)
  df$group <- as.integer(df$group)
  tibble::as_tibble(df)
}

empty_train <- data.frame(
  stringsAsFactors = FALSE,
  order = integer(),
  station = character(),
  name = character(),
  min = integer(),
  to_station = character(),
  to_name = character(),
  group = integer(),
  line = character(),
  cars = integer()
)
