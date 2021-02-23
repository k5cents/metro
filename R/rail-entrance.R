#' Rail Station Entrances
#'
#' Returns a list of nearby station entrances based on latitude, longitude, and
#' radius (meters). Omit search parameters to return all station entrances.
#'
#' @format A tibble 1 row per entrance with 7 variables:
#' \describe{
#'   \item{Name}{Name of the entrance (usually the station name and nearest
#'   intersection).}
#'   \item{StationCode}{The station code associated with this entrance. Use this
#'   value in other rail-related APIs to retrieve data about a station.}
#'   \item{StationTogether}{For stations containing multiple platforms (e.g.:
#'   Gallery Place, Fort Totten, L'Enfant Plaza, and Metro Center), the other
#'   station code (previously `StationCode2`).}
#'   \item{Description}{Additional information for the entrance, if available.
#'   Currently available data usually shows the same value as the `Name`
#'   element.}
#'   \item{Lat}{Latitude.}
#'   \item{Lon}{Longitude.}
#'   \item{Distance}{Distance (meters) of the entrance from the provided search
#'   coordinates. Calculated using [geodist::geodist()] and the "cheap ruler"
#'   method.}
#' }
#'
#' @param Lat (Optional) Center point Latitude, required if `Longitude` and
#'   `Radius` are specified.
#' @param Lon (Optional) Center point Longitude, required if `Latitude` and
#'   `Radius` are specified.
#' @param Radius (Optional) Radius (meters) to include in the search area,
#'   required if `Latitude` and `Longitude` are specified.
#' @inheritParams wmata_key
#' @examples
#' \dontrun{
#' rail_entrance(38.8895, -77.0353)
#' }
#' @return A data frame of station entrances.
#' @seealso <https://developer.wmata.com/docs/services/5476364f031f590f38092507/operations/5476364f031f5909e4fe330f>
#' @family Rail Station Information
#' @importFrom geodist geodist
#' @importFrom tibble as_tibble
#' @export
rail_entrance <- function(Lat = NULL, Lon = NULL, Radius = NULL,
                          api_key = wmata_key()) {
  coord <- list(Lat = Lat, Lon = Lon, Radius = Radius)
  dat <- wmata_api(
    path = "Rail.svc/json/jStationEntrances",
    query = coord,
    flatten = TRUE,
    level = 1,
    api_key = api_key
  )
  if (length(dat) == 0) {
    warning("no entrances found within your radius, please expand")
    return(empty_entrance)
  }
  dat <- dat[, -1] # Deprecated: ID
  dat <- utils::type.convert(dat, na.strings = "", as.is = TRUE)
  if (is.null(Lat) || is.null(Lon)) {
    dist <- NA_real_
  } else {
    dist <- as.vector(geodist::geodist(coord, dat))
  }
  dat$Distance <- dist
  names(dat)[2:3] <- c("StationCode", "StationTogether")
  dat$StationTogether <- as.character(dat$StationTogether)
  tibble::as_tibble(dat[order(dat$Distance), ])
}

empty_entrance <- tibble::tibble(
  Name = character(),
  StationCode = character(),
  StationTogether = character(),
  Description = character(),
  Lat = double(),
  Lon = double(),
  Distance = double()
)
