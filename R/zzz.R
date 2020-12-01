.onAttach <- function(libname, pkgname) {
  if (!nzchar(Sys.getenv("WMATA_KEY", ""))) {
    if (is_installed("usethis")) {
      usethis::ui_todo(
        "No WMATA API key found: \\
        add a key to {usethis::ui_path('.Renviron')} with \\
        {usethis::ui_code('browse_wmata_key()')}"
      )
    } else {
      packageStartupMessage("No WMATA API key found, set on to use package")
    }
  }
}
