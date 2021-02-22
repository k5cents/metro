#' Bus Stop Search
#'
#' Returns a list of nearby bus stops based on latitude, longitude, and radius.
#' Omit all parameters to retrieve a list of all stops.
#'
#' @format A tibble with 1 row per stop and 6 variables:
#' \describe{
#'   \item{StopID}{String array of route variants which provide service at this
#'   stop. Note that these are not date-specific; any route variant which stops
#'   at this stop on any day will be listed.}
#'   \item{Name}{Stop name. May be slightly different from what is spoken or
#'   displayed in the bus.}
#'   \item{Lat}{Latitude.}
#'   \item{Lon}{Longitude.}
#'   \item{Distance}{Distance (meters) of the stop from the provided search
#'   coordinates. Calculated using [geodist::geodist()] and the "cheap ruler"
#'   method.}
#'   \item{Routes}{Character string of route variants which provide service at
#'   this stop. Note that these are not date-specific; any route variant which
#'   stops at this stop on any day will be listed.}
#' }
#' @param Lat Center point Latitude, required if `Longitude` and `Radius` are
#'   specified.
#' @param Lon Center point Longitude, required if `Latitude` and `Radius` are
#'   specified.
#' @param Radius Radius (meters) to include in the search area, required if
#'   `Latitude` and `Longitude` are specified.
#' @inheritParams wmata_api
#' @examples
#' \dontrun{
#' bus_stops(38.8895, -77.0353, 500)
#' }
#' @return Data frame containing stop information
#' @seealso <https://developer.wmata.com/docs/services/54763629281d83086473f231/operations/5476362a281d830c946a3d6d>
#' @family Bus Route and Stop Methods
#' @importFrom geodist geodist
#' @importFrom tibble as_tibble add_column
#' @export
bus_stops <- function(Lat = NULL, Lon = NULL, Radius = NULL,
                      api_key = wmata_key()) {
  coord <- list(Lat = Lat, Lon = Lon, Radius = Radius)
  dat <- wmata_api(
    path = "Bus.svc/json/jStops",
    query = coord,
    flatten = TRUE,
    level = 1,
    api_key = api_key
  )
  if (length(dat) == 0) {
    warning("No bus stops found, please expand your Radius")
    return(empty_stops)
  }
  if (is.null(Lat) || is.null(Lon)) {
    dist <- NA_real_
  } else {
    dist <- as.vector(geodist::geodist(coord, dat))
  }
  dat <- tibble::add_column(dat, .after = "Lat", Distance = dist)
  tibble::as_tibble(dat[order(dat$Distance), ])
}

empty_stops <- tibble::tibble(
  StopID = character(),
  Name = character(),
  Lon = double(),
  Lat = double(),
  Distance = double(),
  Routes = character()
)
