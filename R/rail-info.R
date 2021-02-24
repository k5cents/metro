#' Rail Station Information
#'
#' Returns station location and address information based on a given
#' `StationCode`. Similar to [rail_stations()], but returns data on a given
#' station(s) rather than all stations on a line.
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
#' @param StationCode A character vector of one or more station codes. A
#'   separate call is made to the API for each code, do not provide more than
#'   10.
#' @inheritParams wmata_key
#' @examples
#' \dontrun{
#' station_info(StationCode = c("A07", "B07"))
#' }
#' @return A data frame of stations.
#' @seealso <https://developer.wmata.com/docs/services/5476364f031f590f38092507/operations/5476364f031f5909e4fe3311>
#' @family Rail Station Information
#' @importFrom tibble add_column as_tibble
#' @export
station_info <- function(StationCode, api_key = wmata_key()) {
  n <- length(StationCode)
  if (n > 1) {
    message(sprintf("Calling API %i times, once for each StationCode", n))
  }
  if (n > 9) {
    stop(
      "Refrain from calling the API more than 10 times. ",
      "Try using rail_stations() instead?"
    )
  }
  out <- Map(
    f = stn_info,
    StationCode,
    api_key
  )
  names(out) <- NULL
  rows_bind(out)
}

stn_info <- function(StationCode, api_key) {
  dat <- wmata_api(
    path = "Rail.svc/json/jStationInfo",
    query = list(StationCode = StationCode),
    api_key = api_key
  )
  addr <- dat$Address
  dat <- dat[-length(dat)]
  dat <- lapply(dat, function(x) ifelse(all(is.null(x)), NA_character_, x))
  dat <- utils::type.convert(dat, na.strings = "", as.is = TRUE)
  dat <- as_tibble(c(dat, addr))
  dat <- utils::type.convert(dat, na.strings = "", as.is = TRUE)
  dat <- dat[, -4] # Currently not in use: StationTogether2
  l <- Map(paste, dat[4], dat[5], dat[6])
  l <- strsplit(gsub("\\s?NA\\s?", "", l[[1]]), "\\s")
  dat <- tibble::add_column(dat[, -(4:7)], LineCodes = l, .after = 3)
  tibble::as_tibble(dat)
}
