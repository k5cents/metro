#' Bus position
#'
#' Returns bus positions for the given route, with an optional search radius. If
#' no parameters are specified, all bus positions are returned.
#'
#' Note that the `route` parameter accepts only base route names and no
#' variations, i.e.: use 10A instead of 10Av1 or 10Av2.
#' @format A tibble with 13 variables:
#' \describe{
#'   \item{vehicle}{Unique identifier. Usually visible on the bus itself.}
#'   \item{lat}{Last reported Latitude of the bus.}
#'   \item{lon}{Last reported Longitude of the bus.}
#'   \item{dist}{Distance in meters from provided coordinates.}
#'   \item{deviation}{Deviation, in minutes, from schedule.}
#'   \item{time}{Date and time (EST) of last position update.}
#'   \item{trip}{Unique trip ID. Used with the schedule-related functions.}
#'   \item{route}{Base route name as shown on the bus.}
#'   \item{direction}{General direction of the trip, not the bus itself }
#'   \item{head}{Destination of the bus.}
#'   \item{start}{Scheduled start time (EST) of the bus's current trip.}
#'   \item{end}{Scheduled end time (EST) of the bus's current trip.}
#'   \item{block}{}
#' }
#' @param route Base bus route, e.g.: 70, 10A.
#' @param lat Center point Latitude.
#' @param lon Center point Longitude.
#' @param radius Meters to include in the search area for `lat` and `lon`.
#' @export
bus_position <- function(route = NULL, lat = NULL, lon = NULL, radius = 1000) {
  coord <- list(Lat = lat, Lon = lon, Radius = radius)
  json <- wmata_api(
    type = "Bus", endpoint = "jBusPositions",
    query = c(list(RouteId = route), coord)
  )
  df <- jsonlite::fromJSON(json, flatten = TRUE)[[1]]
  if (length(df) == 0) {
    warning("no routes found within your radius, please expand")
    return(empty_routes)
  }
  df <- df[, -8]
  names(df) <- names(empty_routes)[-4]
  df[c(5, 10:11)] <- lapply(df[c(5, 10:11)], api_time)
  dist <- if (is.null(lat) || is.null(lon)) {
    NA_real_
  } else {
    as.vector(geodist::geodist(coord, df))
  }
  df <- tibble::add_column(df, distance = dist, .after = "lon")
  tibble::as_tibble(df)
}

empty_routes <- data.frame(
  vehicle = character(),
  lat = double(),
  lon = double(),
  distance = double(),
  deviation = double(),
  time = as.POSIXlt(character()),
  trip = character(),
  route = character(),
  direction = character(),
  head = character(),
  start = as.POSIXlt(character()),
  end = as.POSIXlt(character()),
  block = character()
)
