#' Elevator/Escalator Outages
#'
#' @details
#' Note that for stations with multiple platforms and therefore `StationCodes`
#' (e.g.: Metro Center, L'Enfant Plaza, etc.), a distinct call is required for
#' each `StationCode`.
#'
#' @param StationCode Station code. Use [rail_stations()] to return a list of
#'   all station codes. Use `NULL` (default) to list all incidents.
#' @examples
#' \dontrun{
#' elevator_incidents("A01")
#' }
#' @return Data frame of _reported_ elevator and escalator outages.
#' @seealso <https://developer.wmata.com/docs/services/54763641281d83086473f232/operations/54763641281d830c946a3d76>
#' @family Incident APIs
#' @importFrom jsonlite fromJSON
#' @importFrom tibble as_tibble tibble
#' @export
elevator_incidents <- function(StationCode = NULL) {
  json <- wmata_api(
    type = "Incidents", endpoint = "ElevatorIncidents",
    query = list(StationCode = StationCode)
  )
  dat <- jsonlite::fromJSON(json, flatten = TRUE)[[1]]
  if (length(dat) == 0) {
    message("no elevator incidents reported")
    return(empty_elevator)
  }
  # Deprecated: DisplayOrder SymptomCode TimeOutOfService UnitStatus
  dat <- dat[, c(-3, -7, -8, -10)]
  dat[, 7:9] <- lapply(dat[, 7:9], api_time)
  tibble::as_tibble(dat)
}

empty_elevator <- tibble::tibble(
  UnitName = character(),
  UnitType = character(),
  UnitStatus = character(),
  StationCode = character(),
  StationName = character(),
  LocationDescription = character(),
  SymptomCode = character(),
  TimeOutOfService = character(),
  SymptomDescription = character(),
  DisplayOrder = character(),
  DateOutOfServ = as.POSIXct(character()),
  DateUpdated = as.POSIXct(character()),
  EstimatedReturnToService = as.POSIXct(character())
)
