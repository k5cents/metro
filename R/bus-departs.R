#' Bus route and stop methods
#'
#' Returns schedules for a given route variant for a given date.
#'
#' @format A tibble with 13 variables:
#' \describe{
#'   \item{route}{Bus route variant identifier (pattern).}
#'   \item{depart_time}{Date and time (EST) when the bus is scheduled to stop at
#'   this location.}
#'   \item{trip_id}{Trip identifier.}
#'   \item{direction}{General direction of the trip.}
#'   \item{trip_head}{Destination of the bus.}
#'   \item{start_time}{Scheduled start date and time (EST) for this trip.}
#'   \item{end_time}{Scheduled end date and time (EST) for this trip.}
#' }
#' @param stop 7-digit regional stop ID.
#' @param date Date for which to retrieve route and stop information.
#' @export
bus_departs <- function(stop = NULL, date = NULL) {
  json <- wmata_api(
    type = "Bus", endpoint = "jStopSchedule",
    query = list(StopID = stop, Date = date)
  )
  df <- jsonlite::fromJSON(json, flatten = TRUE)[[2]]
  df <- df[, c(5, 1, 8, 6:7, 3:4)]
  names(df) <- c("route", "depart_time", "trip_id", "direction", "trip_head",
                 "start_time", "end_time")
  df[, c(2,6:7)] <- lapply(df[, c(2,6:7)], api_time)
  tibble::as_tibble(df)
}
