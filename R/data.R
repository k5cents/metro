#' All WMATA Rail Stations
#'
#' @details
#' As of 2021-02-22 22:00:00 ET.
#'
#' @format A tibble with 95 rows and 10 variables:
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
"metro_stations"

#' All WMATA Rail Lines
#'
#' @details
#' As of 2021-02-22 22:00:00 ET.
#'
#' @format A tibble with 6 rows and 6 variables:
#' \describe{
#'   \item{LineCode}{Two-letter abbreviation for the line (e.g.: RD, BL, YL, OR,
#'   GR, or SV).}
#'   \item{DisplayName}{Full name of line color.}
#'   \item{StartStationCode}{Start station code. For example, will be F11
#'   (Branch Avenue) for the Green Line, A15 (Shady Grove) for the Red Line,
#'   etc. Use this value in other rail-related APIs to retrieve data about a
#'   station.}
#'   \item{EndStationCode}{End station code. For example, will be E10
#'   (Greenbelt) for the Green Line, B11 (Glenmont) for the Red Line, etc. Use
#'   this value in other rail-related APIs to retrieve data about a station.}
#'   \item{InternalDestination}{Intermediate terminal station code(s). During
#'   normal service, some trains on some lines might end their trip prior to the
#'   `StartStationCode` or `EndStationCode.` A good example is on the Red Line
#'   where some trains stop at A11 (Grosvenor) or B08 (Silver Spring). `NA` if
#'   not defined.}
#' }
"metro_lines"

#' All WMATA Bus Routes
#'
#' @details
#' As of 2021-02-22 22:00:00 ET.
#'
#' @format A tibble 322 rows and 3 variables:
#' \describe{
#'   \item{RouteID}{Unique identifier for a given route variant. Can be used in
#'   various other bus-related methods.}
#'   \item{Name}{Descriptive name of the route variant.}
#'   \item{LineDescription}{Denotes the route variant's grouping - lines are a
#'   combination of routes which lie in the same corridor and which have
#'   significant portions of their paths along the same roadways.}
#' }
"metro_routes"

#' All WMATA Bus Stops
#'
#' @details
#' As of 2021-02-22 22:00:00 ET.
#'
#' @format A tibble with 9,044 rows and 5 variables:
#' \describe{
#'   \item{StopID}{String array of route variants which provide service at this
#'   stop. Note that these are not date-specific; any route variant which stops
#'   at this stop on any day will be listed.}
#'   \item{Name}{Stop name. May be slightly different from what is spoken or
#'   displayed in the bus.}
#'   \item{Lat}{Latitude.}
#'   \item{Lon}{Longitude.}
#'   \item{Routes}{Character string of route variants which provide service at
#'   this stop. Note that these are not date-specific; any route variant which
#'   stops at this stop on any day will be listed.}
#' }
"metro_stops"
