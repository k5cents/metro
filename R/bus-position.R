#' Bus Position
#'
#' Returns bus positions for the given route, with an optional search radius. If
#' no parameters are specified, all bus positions are returned.
#'
#' Note that the `RouteID` parameter accepts only base route names and no
#' variations, i.e.: use 10A instead of 10Av1 or 10Av2.
#'
#' @format A data frame with 1 row per bus and 13 variables:
#' \describe{
#'   \item{VehicleID}{Unique identifier for the bus. This is usually visible on
#'   the bus itself.}
#'   \item{Lat}{Last reported Latitude of the bus.}
#'   \item{Lon}{Last reported Longitude of the bus.}
#'   \item{Distance}{Distance (meters) of the bus from the provided search
#'   coordinates. Calculated using [geodist::geodist()] and the "cheap ruler"
#'   method.}
#'   \item{Deviation}{Deviation, in minutes, from schedule. Positive values
#'   indicate that the bus is running late while negative ones are for buses
#'   running ahead of schedule.}
#'   \item{DateTime}{Date and time (UTC) of last position update.}
#'   \item{TripID}{Unique trip ID. This can be correlated with the data returned
#'   from the schedule-related methods.}
#'   \item{RouteID}{Base route name as shown on the bus. Note that the base
#'   route name could also refer to any variant, so a RouteID of 10A could refer
#'   to 10A, 10Av1, 10Av2, etc.}
#'   \item{DirectionText}{General direction of the trip, not the bus itself
#'   (e.g.: NORTH, SOUTH, EAST, WEST).}
#'   \item{TripHeadsign}{Destination of the bus.}
#'   \item{TripStartTime}{Scheduled start date and time (UTC) of the bus's
#'   current trip.}
#'   \item{TripEndTime}{Scheduled end date and time (UTC) of the bus's current
#'   trip.}
#'   \item{BlockNumber}{}
#' }
#'
#' @param RouteId Base bus route, e.g.: 70, 10A.
#' @param Lat Center point Latitude, required if Longitude and Radius are
#'   specified.
#' @param Lon Center point Longitude, required if Latitude and Radius are
#'   specified.
#' @param Radius Radius (meters) to include in the search area. If `NULL`
#'   (default) when `Lat` and `Lon` are supplied, a generic max of 50 kilometers
#'   is used.
#' @inheritParams wmata_key
#' @examples
#' \dontrun{
#' bus_position("70", 38.8895, -77.0353)
#' }
#' @return Data frame containing bus position information.
#' @seealso <https://developer.wmata.com/docs/services/54763629281d83086473f231/operations/5476362a281d830c946a3d68>
#' @family Bus Route and Stop Methods
#' @importFrom geodist geodist
#' @importFrom jsonlite fromJSON
#' @importFrom tibble add_column as_tibble
#' @export
bus_position <- function(RouteId = NULL, Lat = NULL, Lon = NULL, Radius = NULL,
                         api_key = wmata_key()) {
  if (!is.null(Lat) && !is.null(Lon) && is.null(Radius)) {
    Radius <- 50000
  }
  coord <- list(Lat = Lat, Lon = Lon, Radius = Radius)
  dat <- wmata_api(
    path = "Bus.svc/json/jBusPositions",
    query = c(list(RouteId = RouteId), coord),
    flatten = TRUE,
    level = 1
  )
  if (no_data_now(dat)) {
    message("No routes found within your radius, please expand")
    return(empty_positions)
  }
  dat <- dat[, -8] # DirectionNum Deprecated
  dat[c(5, 10:11)] <- lapply(dat[c(5, 10:11)], FUN = api_time)
  if (is.null(Lat) || is.null(Lon)) {
    dist <- NA_real_
  } else {
    dist <- as.vector(geodist::geodist(coord, dat))
  }
  dat <- tibble::add_column(dat, Distance = dist, .after = "Lon")
  tibble::as_tibble(dat)
}

empty_positions <- tibble::tibble(
  VehicleID = character(),
  Lat = double(),
  Lon = double(),
  Distance = double(),
  Deviation = double(),
  DateTime = as.POSIXct(character()),
  TripID = character(),
  RouteID = character(),
  DirectionText = character(),
  TripHeadsign = character(),
  TripStartTime = as.POSIXct(character()),
  TripEndTime = as.POSIXct(character()),
  BlockNumber = character()
)














