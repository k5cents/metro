#' Bus incidents
#'
#' Returns a set of reported bus incidents/delays for a given Route.
#'
#' Note that the Route parameter accepts only base route names and no
#' variations, i.e.: use 10A instead of 10Av1 and 10Av2.
#' @param route Base bus route; variations are not recognized. Omit the Route to
#'   return all reported items (default).
#' @export
bus_incidents <- function(route = NULL) {
  json <- wmata_api("Incidents", "BusIncidents", list(Route = route))
  jsonlite::fromJSON(json, flatten = TRUE)
}
