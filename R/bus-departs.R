#' Bus Route and Stop Methods
#'
#' Returns a set of buses scheduled at a stop for a given date.
#'
#' @format A tibble with 13 variables:
#' \describe{
#'   \item{RouteID}{Bus route variant identifier (pattern). This variant can be
#'   used in several other bus methods which accept variants. Note that
#'   customers will never see anything other than the base route name, so
#'   variants 10A, 10Av1, 10Av2, etc. will be displayed as 10A on the bus.}
#'   \item{ScheduleTime}{Date and time (UTC) when the bus is scheduled to stop
#'   at this location.}
#'   \item{TripID}{Trip identifier. This can be correlated with the data in our
#'   bus schedule information as well as bus positions.}
#'   \item{TripDirectionText}{General direction of the trip (e.g.: NORTH, SOUTH,
#'   EAST, WEST).}
#'   \item{TripHeadsign}{Destination of the bus.}
#'   \item{StartTime}{Scheduled start date and time (UTC) for this trip.}
#'   \item{EndTime}{Scheduled end date and time (UTC) for this trip.}
#' }
#' @param stop 7-digit regional stop ID.
#' @param date (Optional) Date for which to retrieve route and stop information.
#' @examples
#' \dontrun{
#' bus_departs(2000474, "2021-02-16")
#' }
#' @family Bus Route and Stop Methods
#' @seealso <https://developer.wmata.com/docs/services/54763629281d83086473f231/operations/5476362a281d830c946a3d6c/console>
#' @export
bus_departs <- function(stop, date = NULL) {
  json <- wmata_api(
    type = "Bus", endpoint = "jStopSchedule",
    query = list(StopID = stop, Date = date)
  )
  dat <- jsonlite::fromJSON(json, flatten = TRUE)[[2]]
  dat <- dat[, c(5, 1, 8, 6:7, 3:4)]
  dat[, c(2,6:7)] <- lapply(dat[, c(2, 6:7)], api_time)
  tibble::as_tibble(dat)
}
