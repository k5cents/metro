#' Next Trains
#'
#' @description
#' Returns next train arrival information for one or more stations. Will return
#' an empty set of results when no predictions are available. Use "All" for the
#' `StationCodes` parameter to return predictions for all stations.
#'
#' @details
#' For terminal stations (e.g.: Greenbelt, Shady Grove, etc.), predictions may
#' be displayed twice.
#'
#' Some stations have two platforms (e.g.: Gallery Place, Fort Totten, L'Enfant
#' Plaza, and Metro Center). To retrieve complete predictions for these
#' stations, be sure to pass in both StationCodes.
#'
#' For trains with no passengers, the `DestinationName` will be "No Passenger".
#'
#' @format A tibble 1 row per arrival with 9 variables:
#' \describe{
#'   \item{Car}{Number of cars on a train, usually 6 or 8, but might also `NA`.}
#'   \item{Destination}{Abbreviated version of the final destination for a
#'   train. This is similar to what is displayed on the signs at stations.}
#'   \item{DestinationCode}{}Destination station code. Can be `NA`. Use this
#'   value in other rail-related APIs to retrieve data about a station.
#'   \item{DestinationName}{When `DestinationCode` is populated, this is the
#'   full name of the destination station, as shown on the WMATA website.}
#'   \item{Group}{Denotes the track this train is on, but does not necessarily
#'   equate to Track 1 or Track 2. With the exception of terminal stations,
#'   predictions at the same station with different Group values refer to trains
#'   on different tracks.}
#'   \item{Line}{Two-letter abbreviation for the line (e.g.: RD, BL, YL, OR, GR,
#'   or SV). May also be `NA` for trains with no passengers.}
#'   \item{LocationCode}{Station code for where the train is arriving. Useful
#'   when passing in All as the `StationCodes` parameter. Use this value in
#'   other rail-related APIs to retrieve data about a station.}
#'   \item{LocationName}{Full name of the station where the train is arriving.
#'   Useful when passing in "All" as the `StationCodes` parameter.}
#'   \item{Min}{Minutes until arrival. Can be a numeric value, 0 (arriving),
#'   -1 (boarding), or `NA`.}
#' }
#'
#' @param StationCodes Character vector of station codes. For all predictions,
#'   use `NULL` (default) or "All".
#' @inheritParams wmata_key
#' @examples
#' \dontrun{
#' next_train(StationCodes = c("A02", "B02"))
#' }
#' @return Data frame of train arrivals.
#' @seealso <https://developer.wmata.com/docs/services/547636a6f9182302184cda78/operations/547636a6f918230da855363f>
#' @family Real-Time Predictions
#' @importFrom tibble as_tibble
#' @export
next_train <- function(StationCodes = NULL, api_key = wmata_key()) {
  if (all(is.null(StationCodes))) {
    StationCodes <- "All"
  }
  dat <- wmata_api(
    path = paste0(
      "StationPrediction.svc/json/GetPrediction/",
      paste(StationCodes, collapse = ",")
    ),
    flatten = TRUE,
    level = 1,
    api_key = api_key
  )
  if (no_data_now(dat)) {
    message("No next trains arriving at this station")
    return(empty_next_train)
  }
  dat$Min[dat$Min == "ARR"] <- 0L
  dat$Min[dat$Min == "BRD"] <- -1L
  dat$Min[dat$Min == "---" | dat$Min == ""] <- NA_integer_
  dat$Car[dat$Car == "-"] <- NA_integer_
  dat$Line[dat$Line == "No"] <- NA_character_
  dat$Min <- as.integer(dat$Min)
  dat$Group <- as.integer(dat$Group)
  dat$Car <- as.integer(dat$Car)
  tibble::as_tibble(dat)
}

empty_next_train <- tibble::tibble(
  Car = integer(),
  Destination = character(),
  DestinationCode = character(),
  DestinationName = character(),
  Group = integer(),
  Line = character(),
  LocationCode = character(),
  LocationName = character(),
  Min = integer()
)
