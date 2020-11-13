#' Get your WMATA API key
#'
#' All calls to the WMATA API must be accompanied by a personal API key. A free
#' key can be obtained by subscribing to the default tier. See
#' [browse_wmata_key()] for more information on getting a key and storing on
#' your system.
#'
#' @details
#' From the WMATA developer website:
#' Default tier sufficient for most casual developers. Rate limited to 10
#' calls/second and 50,000 calls per day. This product contains 8 APIs:
#' * Bus Route and Stop Methods
#' * GTFS
#' * Incidents
#' * Misc Methods
#' * Rail Station Information
#' * Real-Time Bus Predictions
#' * Real-Time Rail Predictions
#' * Train Positions
#' @export
wmata_key <- function () {
  key <- Sys.getenv("WMATA_KEY", "")
  if (!nzchar(key)) {
    if (is_installed("usethis")) {
      usethis::ui_stop("no WMATA key found, see \\
                       {usethis::ui_code('browse_wmata_key()')}")
    } else {
      stop("no WMATA key found, see `browse_wmata_key()`")
    }
  } else {
    return(key)
  }
}

#' @rdname wmata_key
#' @export
browse_wmata_key <- function() {
  if (is_installed("usethis")) {
    x <- "https://developer.wmata.com/signup/"
    y <- "https://developer.wmata.com/products/5475f1b0031f590f380924fe"
    z <- "https://developer.wmata.com/developer"
    ui_url <- function(x) crayon::italic(crayon::blue(sprintf("<%s>", x)))
    usethis::ui_todo("Sign up for a WMATA developer account {ui_url(x)}")
    usethis::ui_todo("Subscribe to the free default tier {ui_url(y)}")
    usethis::ui_todo("Copy the {usethis::ui_field('Primary Key')} \\
                     from your profile {ui_url(z)}")
    usethis::ui_todo("Call {usethis::ui_code('usethis::edit_r_environ()')} \\
                     to open {usethis::ui_path('.Renviron')}.")
    usethis::ui_todo("Store your WMATA key with a line like:")
    usethis::ui_code_block("WMATA_KEY=xxxyyyzzz")
    usethis::ui_todo("Make sure {usethis::ui_value('.Renviron')} ends with \\n")
    # invisible()
  } else {
    stop("The \"usethis\" package needed for key instructions", call. = FALSE)
  }
}
