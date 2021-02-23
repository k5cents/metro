#' Bus Schedule at Stop
#'
#' Returns a set of buses scheduled at a stop for a given date.
#'
#' @format A tibble with 1 row per bus departure and 8 variables:
#' \describe{
#'   \item{ScheduleTime}{Date and time (UTC) when the bus is scheduled to stop
#'   at this location.}
#'   \item{DirectionNum}{Denotes a binary direction (0 or 1) of the bus. There
#'   is no specific mapping to direction, but a different value for the same
#'   route signifies that the buses are traveling in opposite directions. Use
#'   the `TripDirectionText` column to show the actual destination of the bus.}
#'   \item{StartTime}{Scheduled start date and time (UTC) for this trip.}
#'   \item{EndTime}{Scheduled end date and time (UTC) for this trip.}
#'   \item{RouteID}{Bus route variant identifier (pattern). This variant can be
#'   used in several other bus methods which accept variants. Note that
#'   customers will never see anything other than the base route name, so
#'   variants 10A, 10Av1, 10Av2, etc. will be displayed as 10A on the bus.}
#'   \item{TripDirectionText}{General direction of the trip (e.g.: NORTH, SOUTH,
#'   EAST, WEST).}
#'   \item{TripHeadsign}{Destination of the bus.}
#'   \item{TripID}{Trip identifier. This can be correlated with the data in our
#'   bus schedule information as well as bus positions.}
#' }
#'
#' @param StopID 7-digit regional stop ID.
#' @param Date (Optional) Date for which to retrieve route and stop information.
#' @inheritParams wmata_key
#' @examples
#' \dontrun{
#' bus_departs(1001195, "2021-01-01")
#' }
#' @return Data frame containing scheduled arrival information.
#' @seealso <https://developer.wmata.com/docs/services/54763629281d83086473f231/operations/5476362a281d830c946a3d6c/console>
#' @family Bus Route and Stop Methods
#' @importFrom tibble as_tibble
#' @export
bus_departs <- function(StopID, Date = NULL, api_key = wmata_key()) {
  dat <- wmata_api(
    path = "Bus.svc/json/jStopSchedule",
    query = list(StopID = StopID, Date = Date),
    flatten = TRUE,
    level = 2,
    api_key = api_key
  )
  dat[, c(1, 3:4)] <- lapply(dat[, c(1, 3:4)], api_time)
  tibble::as_tibble(dat)
}
