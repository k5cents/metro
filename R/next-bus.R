#' Next Buses
#'
#' Returns next bus arrival times at a stop.
#'
#' @format A tibble 1 row per arrival with 6 variables:
#' \describe{
#'   \item{RouteID}{Base route name as shown on the bus. This can be used in
#'   other bus-related methods. Note that all variants will be shown as their
#'   base route names (i.e.: 10Av1 and 10Av2 will be shown as 10A).}
#'   \item{DirectionText}{Customer-friendly description of direction and
#'   destination for a bus.}
#'   \item{DirectionNum}{Denotes a binary direction (0 or 1) of the bus. There
#'   is no specific mapping to direction, but a different value for the same
#'   route signifies that the buses are traveling in opposite directions. Use
#'   the DirectionText element to show the actual destination of the bus.}
#'   \item{Minutes}{Minutes until bus arrival at this stop. Numeric value.}
#'   \item{VehicleID}{Bus identifier. This can be correlated with results
#'   returned from bus positions.}
#'   \item{TripID}{Trip identifier. This can be correlated with the data in our
#'   bus schedule information as well as bus positions.}
#' }
#' @param StopID 7-digit regional stop ID.
#' @examples
#' \dontrun{
#' next_bus(stopID = "1001195")
#' }
#' @return Data frame of bus arrivals
#' @seealso <https://developer.wmata.com/docs/services/5476365e031f590f38092508/operations/5476365e031f5909e4fe331d>
#' @family Real-Time Predictions
#' @importFrom jsonlite fromJSON
#' @importFrom tibble as_tibble
#' @export
next_bus <- function(StopID = NULL) {
  json <- wmata_api(
    type = "NextBusService",
    endpoint = "jPredictions",
    query = list(StopID = StopID)
  )
  dat <- jsonlite::fromJSON(json, flatten = TRUE)[[2]]
  tibble::as_tibble(dat)
}
