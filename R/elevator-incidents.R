#' Bus incidents
#'
#' Returns a list of reported elevator and escalator outages at a given station.
#'
#' Note that for stations with multiple platforms and therefore `station` codes
#' (e.g.: Metro Center, L'Enfant Plaza, etc.), a distinct call is required for
#' each code.
#' @param station Station code. Omit to return all reported outages (default).
#' @source <https://api.wmata.com/Incidents.svc/json/ElevatorIncidents>
#' @export
elevator_incidents <- function(station = NULL) {
  json <- wmata_api(
    type = "Incidents", endpoint = "ElevatorIncidents",
    query = list(StationCode = station)
  )
  df <- jsonlite::fromJSON(json, flatten = TRUE)[[1]]
  if (length(df) == 0) {
    message("no elevator incidents reported")
    return(empty_elevator)
  }
  df <- df[, c(-3, -7, -8, -10)]
  names(df) <- names(empty_elevator)
  df[, 7:9] <- lapply(df[, 7:9], api_time)
  tibble::as_tibble(df)
}

empty_elevator <- data.frame(
  unit_name = character(),
  unit_type = character(),
  station = character(),
  station_name = character(),
  location = character(),
  symptom = character(),
  date_broken = as.Date(character()),
  date_updated = as.Date(character()),
  date_return = as.Date(character())
)
