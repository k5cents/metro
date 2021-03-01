#' Bus Incidents
#'
#' Returns a set of reported bus incidents/delays for a given Route. Omit the
#' Route to return all reported items.
#'
#' Note that the Route parameter accepts only base route names and no
#' variations, i.e.: use 10A instead of 10Av1 and 10Av2.
#'
#' @format A data frame with 1 row per incident and 5 variables:
#' \describe{
#'   \item{IncidentID}{Unique identifier for an incident.}
#'   \item{IncidentType}{Free-text description of the incident type. Usually
#'   `Delay` or `Alert` but is subject to change at any time.}
#'   \item{RoutesAffected}{Character string of routes affected. Routes listed
#'   are usually identical to base route names (i.e.: not 10Av1 or 10Av2, but
#'   10A), but may differ from what our bus methods return.}
#'   \item{Description}{Free-text description of the delay or incident.}
#'   \item{DateUpdated}{Date and time (UTC) of last update.}
#' }
#'
#' @param Route Base bus route; variations are not recognized (i.e.: C2 instead
#'   of C2v1, C2v2, etc.).
#' @inheritParams wmata_key
#' @examples
#' \dontrun{
#' bus_incidents()
#' }
#' @return Data frame of bus incidents and delays.
#' @seealso <https://developer.wmata.com/docs/services/54763641281d83086473f232/operations/54763641281d830c946a3d75>
#' @family Incident APIs
#' @importFrom tibble as_tibble tibble
#' @export
bus_incidents <- function(Route = NULL, api_key = wmata_key()) {
  dat <- wmata_api(
    path = "Incidents.svc/json/BusIncidents",
    query = list(Route = Route),
    flatten = TRUE,
    level = 1
  )
  if (no_data_now(dat)) {
    message("No bus incidents reported")
    return(empty_bus_incident)
  }
  dat$DateUpdated <- api_time(dat$DateUpdated)
  tibble::as_tibble(dat)
}

empty_bus_incident <- tibble::tibble(
  IncidentID = character(),
  IncidentType = character(),
  RoutesAffected = character(),
  Description = character(),
  DateUpdated = as.POSIXct(character())
)
