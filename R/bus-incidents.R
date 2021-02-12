#' Bus Incidents
#'
#' Returns a set of reported bus incidents/delays for a given Route.
#'
#' Note that the Route parameter accepts only base route names and no
#' variations, i.e.: use 10A instead of 10Av1 and 10Av2.
#' @param route (Optional) Bus route. Use full route code, i.e.: C2 instead of
#'   C2v1, C2v2, etc. Omit the Route to return all reported items (default).
#' @family Incidents
#' @seealso <https://developer.wmata.com/docs/services/54763641281d83086473f232/operations/54763641281d830c946a3d75>
#' @export
bus_incidents <- function(route = NULL) {
  json <- wmata_api("Incidents", "BusIncidents", list(Route = route))
  jsonlite::fromJSON(json, flatten = TRUE)
}
