#' Bus Schedule
#'
#' Returns schedules for a given route variant for a given date.
#'
#' @format A data frame with 1 row per trip and 10 variables:
#' \describe{
#'   \item{RouteID}{Bus route variant. This can be used in several other bus
#'   methods which accept variants.}
#'   \item{TripDirectionText}{General direction of the trip (NORTH, SOUTH, EAST,
#'   WEST, LOOP, etc.).}
#'   \item{TripHeadsign}{Descriptive text of where the bus is headed. This is
#'   similar, but not necessarily identical, to what is displayed on the bus.}
#'   \item{StartTime}{Scheduled start date and time (UTC) for this trip.}
#'   \item{EndTime}{Scheduled end date and time (UTC) for this trip.}
#'   \item{TripID}{Unique trip ID. This can be correlated with the data returned
#'   from the schedule-related methods.}
#'   \item{StopID}{7-digit regional ID which can be used in various bus-related
#'   methods. If unavailable, the `StopID` will be 0 or `NA`}
#'   \item{StopName}{Stop name. May be slightly different from what is spoken or
#'   displayed in the bus.}
#'   \item{StopSeq}{Order of the stop in the sequence of StopTimes.}
#'   \item{Time}{Scheduled departure date and time (UTC) from this stop.}
#' }
#' @param RouteID Bus route variant, e.g.: 70, 10A, 10Av1, etc.
#' @param Date (Optional) Date for which to retrieve route and stop information.
#' @param IncludingVariations Whether or not to include variations if a base
#'   route is specified in RouteID. For example, if B30 is specified and
#'   `IncludingVariations` is set to `TRUE` (default), data for all variations
#'   of B30 such as B30v1, B30v2, etc. will be returned.
#' @inheritParams wmata_key
#' @examples
#' \dontrun{
#' bus_schedule("70")
#' }
#' @return Data frame containing trip information
#' @seealso <https://developer.wmata.com/docs/services/54763629281d83086473f231/operations/5476362a281d830c946a3d6b>
#' @family Bus Route and Stop Methods
#' @importFrom tibble add_column as_tibble
#' @export
bus_schedule <- function(RouteID, IncludingVariations = TRUE, Date = NULL,
                         api_key = wmata_key()) {
  dat <- wmata_api(
    path = "Bus.svc/json/jRouteSchedule",
    query = list(
      RouteID = RouteID,
      IncludingVariations = IncludingVariations,
      Date = Date
    ),
    flatten = TRUE,
    api_key = api_key
  )
  dir0_stops <- dat$Direction0$StopTimes
  dir0_stops <- rows_bind(dir0_stops, dat$Direction0$TripID, "TripID")
  dat$Direction0 <- merge2(dat$Direction0[, -7], dir0_stops)
  if (!is.null(dat$Direction1)) {
    dir1_stops <- dat$Direction1$StopTimes
    dir1_stops <- rows_bind(dir1_stops, dat$Direction1$TripID, "TripID")
    dat$Direction1 <- merge2(dat$Direction1[, -7], dir0_stops)
    dat <- rbind(dat$Direction0, dat$Direction1)
  } else {
    dat <- dat$Direction0
  }
  dat[, c(5:6, 11)] <- lapply(dat[, c(5:6, 11)], api_time)
  dat <- dat[, -2] # DirectionNum Deprecated
  tibble::as_tibble(dat)
}
