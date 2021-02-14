#' Rail Incidents
#'
#' Returns reported rail incidents (significant disruptions and delays to normal
#' service). The data is identical to WMATA's Metrorail Service Status feed.
#' @format A data frame with 1 row per bus and 13 variables:
#' \describe{
#'   \item{VehicleID}{Unique identifier for the bus. This is usually visible on
#'   the bus itself.}
#' }
#' @examples
#' \dontrun{
#' rail_incidents()
#' }
#' @return Data frame of all rail incidents.
#' @seealso <https://developer.wmata.com/docs/services/54763641281d83086473f232/operations/54763641281d830c946a3d77>
#' @family Incident APIs
#' @importFrom jsonlite fromJSON
#' @importFrom tibble as_tibble tibble
#' @export
rail_incidents <- function() {
  json <- wmata_api(type = "Incidents", endpoint = "Incidents")
  dat <- jsonlite::fromJSON(json, flatten = TRUE)[[1]]
  if (length(dat) == 0) {
    message("no rail incidents reported")
    return(empty_incidents)
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

empty_incidents <- tibble::tibble(
  incident = character(),
  type = character(),
  lines = character(),
  updated = as.POSIXct(character()),
  description = character()
)
