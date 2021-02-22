#' Elevator/Escalator Outages
#'
#' @details
#' Note that for stations with multiple platforms and therefore `StationCodes`
#' (e.g.: Metro Center, L'Enfant Plaza, etc.), a distinct call is required for
#' each `StationCode`.
#'
#' @format A data frame with 1 row per incident and 9 variables:
#' \describe{
#'   \item{UnitName}{Unique identifier for unit, by type (a single elevator and
#'   escalator may have the same `UnitName`, but no two elevators or two
#'   escalators will have the same `UnitName`).}
#'   \item{UnitType}{Type of unit. Will be `ELEVATOR` or `ESCALATOR`.}
#'   \item{StationCode}{Unit's station code. Use this value in other
#'   rail-related APIs to retrieve data about a station.}
#'   \item{StationName}{Full station name, may include entrance information
#'   (e.g.: Metro Center, G and 11th St Entrance).}
#'   \item{LocationDescription}{Free-text description of the unit location
#'   within a station (e.g.: Escalator between mezzanine and platform).}
#'   \item{SymptomDescription}{Description for why the unit is out of service or
#'   otherwise in reduced operation.}
#'   \item{DateOutOfServ}{Date and time (UTC) unit was reported out of service.}
#'   \item{DateUpdated}{Date and time (UTC) outage details was last updated.}
#'   \item{EstimatedReturnToService}{Estimated date and time (UTC) by when unit
#'   is expected to return to normal service. May be NULL.}
#' }
#'
#' @param StationCode Station code. Use [rail_stations()] to return a list of
#'   all station codes. Use `NULL` (default) to list all incidents.
#' @inheritParams wmata_key
#' @examples
#' \dontrun{
#' elevator_incidents()
#' }
#' @return Data frame of _reported_ elevator and escalator outages.
#' @seealso <https://developer.wmata.com/docs/services/54763641281d83086473f232/operations/54763641281d830c946a3d76>
#' @family Incident APIs
#' @importFrom tibble as_tibble tibble
#' @export
elevator_incidents <- function(StationCode = NULL, api_key = wmata_key()) {
  dat <- wmata_api(
    path = "Incidents.svc/json/ElevatorIncidents",
    query = list(StationCode = StationCode),
    flatten = TRUE,
    level = 1,
    api_key = api_key
  )
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
