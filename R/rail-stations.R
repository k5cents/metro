#' Rail Station List
#'
#' Returns a list of station location and address information based on a given
#' `LineCode`. Use `NULL` (default) to return all stations. The response is an
#' data frame identical to that returned in the Station Information method.
#'
#' @format A tibble 1 row per station with 10 variables:
#' \describe{
#'   \item{StationCode}{Station code for this station. Use this value in other
#'   rail-related APIs to retrieve data about a station.}
#'   \item{StationName}{Full name for this station, as shown on the WMATA
#'   website.}
#'   \item{StationTogether}{For stations with multiple platforms (e.g.: Gallery
#'   Place, Fort Totten, L'Enfant Plaza, and Metro Center), the additional
#'   `StationCode` will be listed here.}
#'   \item{LineCodes}{Character vector of two-letter abbreviations (e.g.: RD,
#'   BL, YL, OR, GR, or SV) served by this station. If the station has an
#'   additional platform, the lines served by the other platform are listed in
#'   the `LineCodes` values for the record associated with the `StationCode`
#'   found in `StationTogether.`}
#'   \item{Lat}{Latitude.}
#'   \item{Lon}{Longitude.}
#'   \item{Street}{Street address (for GPS use).}
#'   \item{City}{City.}
#'   \item{State}{State (abbreviated).}
#'   \item{Zip}{Zip code.}
#' }
#'
#' @param LineCode Two-letter line code abbreviation, or `NULL` (default):
#' * RD - Red
#' * YL - Yellow
#' * GR - Green
#' * BL - Blue
#' * OR - Orange
#' * SV - Silver
#' @inheritParams wmata_key
#' @examples
#' \dontrun{
#' rail_stations("RD")
#' }
#' @return A data frame of stations on a rail line.
#' @seealso <https://developer.wmata.com/docs/services/5476364f031f590f38092507/operations/5476364f031f5909e4fe3311>
#' @family Rail Station Information
#' @importFrom tibble add_column as_tibble
#' @export
rail_stations <- function(LineCode = NULL, api_key = wmata_key()) {
  dat <- wmata_api(
    path = "Rail.svc/json/jStations",
    query = list(LineCode = LineCode),
    flatten = TRUE,
    level = 1,
    api_key = api_key
  )
  dat <- utils::type.convert(dat, na.strings = "", as.is = TRUE)
  dat <- dat[, -4] # Currently not in use: StationTogether2
  l <- Map(paste, dat[4], dat[5], dat[6])
  l <- strsplit(gsub("\\s?NA\\s?", "", l[[1]]), "\\s")
  dat <- tibble::add_column(dat[, -(4:7)], LineCodes = l, .after = 3)
  names(dat)[1:3] <- c("StationCode", "StationName", "StationTogether")
  names(dat)[7:10] <- gsub("Address\\.", "", names(dat)[7:10])
  dat$Zip <- as.character(dat$Zip)
  tibble::as_tibble(dat)
}
