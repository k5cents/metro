## Test environments

* local: ubuntu-20.04 (release), R 4.0.4
* github actions: ubuntu-20.04, macOS-latest, windows-latest 
  * <https://github.com/kiernann/metro/actions>
* r-hub: windows-x86_64-devel, ubuntu-gcc-release, fedora-clang-devel
  * <https://builder.r-hub.io/status/metro_0.9.1.tar.gz-31655d1309114fa298c76de2c40bd561>
  * <https://builder.r-hub.io/status/metro_0.9.1.tar.gz-8190b69e7e6142faafac8a996f68fc73>
  * <https://builder.r-hub.io/status/metro_0.9.1.tar.gz-c7dc145bc2ee49cf9656fb7ef256404f>

Tests are run on both GitHub Actions and r-hub by supplying the API key as an
environment variable. Tests are not run without an API key on the system.

## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new release.

## Submission

* Fixed some of the broken links. All of the links to 
  <https://developer.wmata.com/docs/> return a 500 error in the automated check
  but they seem to work fine in a web browser. I will have to remove them all
  if the package can't pass the automated checks.

* Updated package doc help page with `usethis::use_package_doc()`.

* All functions require a valid free API key. A demo key can be found on the
  WMATA products page. Examples are not run. Tests are skipped if a key is not
  found as an environmental variable named `WMATA_KEY`.
