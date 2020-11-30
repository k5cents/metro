#' Next buses
#'
#' Returns next bus arrival times at a stop.
#'
#' @format A tibble with 6 variables:
#' \describe{
#'   \item{route}{Base route name as shown on the bus.}
#'   \item{direction}{Friendly description of direction and destination.}
#'   \item{dir_num}{Denotes a binary direction (0 or 1) of the bus. There is no
#'   specific mapping to direction, but a different value for the same route
#'   signifies that the buses are traveling in opposite directions.}
#'   \item{minutes}{Minutes until bus arrival at this stop.}
#'   \item{vehicle}{Bus identifier.}
#'   \item{trip}{Trip identifier.}
#' }
#' @source <https://api.wmata.com/NextBusService.svc/json/jPredictions>
#' @param stop 7-digit regional stop ID.
#' @export
next_bus <- function(stop = NULL) {
  json <- wmata_api(
    type = "NextBusService",
    endpoint = "jPredictions",
    query = list(StopID = stop)
  )
  df <- jsonlite::fromJSON(json, flatten = TRUE)[[2]]
  names(df) <- c("route", "direction", "dir_num", "minutes", "vehicle", "trip")
  tibble::as_tibble(df)
}
