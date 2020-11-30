#' Call the WMATA API
#'
#' Use [httr::GET()] to make a request to the WMATA API and return the unparsed
#' JSON string. This function is used in others devoted to a
#' specific APIs and endpoints.
#'
#' This function was modified from zamorarr's wmata on GitHub:
#' <https://github.com/zamorarr/wmata/blob/master/R/api.r>
#' @param type The API base type to call, one of "Rail" or "Bus".
#' @param endpoint The API endpoint (e.g., "jStations").
#' @param query Additional queries also passed, possibly your key if need be.
#' @return A single JSON string.
#' @examples
#' \dontrun{
#' wmata_api("Rail", "jLines", query = list(LineCode = "RD"))
#' }
#' @importFrom httr modify_url GET add_headers http_type content http_error
#'   status_code
#' @importFrom jsonlite fromJSON
#' @keywords internal
wmata_api <- function(type = c("Rail", "Bus", "Incidents", "NextBusService",
                               "StationPrediction"), endpoint, query = NULL) {
  type <- match.arg(type)
  stopifnot(length(endpoint) == 1L)
  path <- paste0(type, ".svc/json/", endpoint)
  api <- httr::modify_url("https://api.wmata.com", path = path, query = query)
  request <- httr::add_headers(
    `api_key` = wmata_key(),
    `Content-Type` = "application/json",
    `Accept` = "application/json"
  )
  response <- httr::GET(api, config = request)
  if (httr::http_type(response) != "application/json") {
    stop("API did not return json", call. = FALSE)
  }
  content <- httr::content(response, as = "text", encoding = "UTF-8")
  json <- jsonlite::fromJSON(content, simplifyVector = FALSE)
  if (httr::http_error(response)) {
    stop(
      sprintf(
        "WMATA API request failed with status %s and message:\n%s",
        httr::status_code(response), json$Message
      ), call. = FALSE
    )
  }
  return(content)
}
