## Test environments

* local: ubuntu-20.04 (release)
* github actions: ubuntu-20.04 (release, devel)
  * <https://github.com/kiernann/metro/actions>
* github actions: macOS-latest (release)
* github actions: windows-latest (release) 
* r-hub: windows-x86_64-devel, ubuntu-gcc-release, fedora-clang-devel
  * <https://builder.r-hub.io/status/metro_1.0.0.tar.gz-7e8249e3096a4fba85ba23d760b4b191>
  * <https://builder.r-hub.io/status/metro_1.0.0.tar.gz-414cb8441dbc4fa7a38c1d1a8e993e5d>
  * <https://builder.r-hub.io/status/metro_1.0.0.tar.gz-4d492e0aeefa4de5ac23adad086f1551>

## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new release.

## Submission

* All functions require a valid WMATA API key. The `wmata_demo()` function
can be used to scrap a demo key. All tests call `skip_if_no_key()` which checks
`wmata_key()` for the "WMATA_KEY" environmental variable.
