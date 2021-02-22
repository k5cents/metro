#' Rail Incidents
#'
#' Reported rail incidents (significant disruptions and delays to normal
#' service). The data is identical to WMATA's [Metrorail Service Status
#' feed][1].
#'
#' [1]: http://www.metroalerts.info/rss.aspx?rs
#'
#' @format A data frame with 1 row incident and 5 variables:
#' \describe{
#'   \item{IncidentID}{Unique identifier for an incident.}
#'   \item{Description}{Free-text description of the incident.}
#'   \item{IncidentType}{Free-text description of the incident type. Usually
#'   Delay or Alert but is subject to change at any time.}
#'   \item{LinesAffected}{Character vector of line codes (e.g.: RD; or BL; OR;
#'   or BL; OR; RD;).}
#'   \item{DateUpdated}{Date and time (UTC) of last update.}
#' }
#'
#' @inheritParams wmata_key
#' @examples
#' \dontrun{
#' rail_incidents()
#' }
#' @return Data frame of all rail incidents.
#' @seealso <https://developer.wmata.com/docs/services/54763641281d83086473f232/operations/54763641281d830c946a3d77>
#' @family Incident APIs
#' @importFrom tibble as_tibble tibble
#' @export
rail_incidents <- function(api_key = wmata_key()) {
  dat <- wmata_api(
    path = "Incidents.svc/json/Incidents",
    flatten = TRUE,
    level = 1,
    api_key = api_key
  )
  if (length(dat) == 0) {
    message("No rail incidents reported")
    return(empty_rail_incidents)
  }
  # Deprecated: DelaySeverity EmergencyText EndLocationFullName PassengerDelay
  # StartLocationFullName
  dat <- dat[, -c(3:6, 8)]
  dat[[4]] <- strsplit(dat[[4]], ";\\s?")
  if (all(vapply(dat[[4]], length, double(1)) == 1)) {
    dat[[4]] <- unlist(dat[[4]])
  }
  dat[[5]] <- api_time(dat[[5]])
  tibble::as_tibble(dat)
}

empty_rail_incidents <- tibble::tibble(
  incident = character(),
  type = character(),
  lines = character(),
  updated = as.POSIXct(character()),
  description = character()
)
