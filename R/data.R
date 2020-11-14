#' All WMATA rail stations
#'
#' @format A data frame with 95 rows and 10 variables:
#' \describe{
#'   \item{station}{Station code.}
#'   \item{name}{Station name.}
#'   \item{txfer}{For stations with multiple platforms, the additional code.}
#'   \item{lines}{Vector of line codes services by station.}
#'   \item{lat}{Latitude.}
#'   \item{lon}{Longitude.}
#'   \item{street}{Street address (for GPS use).}
#'   \item{city}{City.}
#'   \item{state}{State (abbreviated).}
#'   \item{zip}{Zip code.}
#'   ...
#' }
#' @source <https://api.wmata.com/Rail.svc/json/jStations>
"stations"

#' All WMATA rail lines
#'
#' @format A data frame with 95 rows and 10 variables:
#' \describe{
#'   \item{line}{Two-letter abbreviation for the line.}
#'   \item{name}{Full name of line color.}
#'   \item{start}{Start station code.}
#'   \item{end}{End station code.}
#'   ...
#' }
#' @source <https://api.wmata.com/Rail.svc/json/jLines>
"lines"
