## Test environments

* local: ubuntu-20.04 (release), R 4.0.4
* github actions: ubuntu-20.04, macOS-latest, windows-latest 
  * <https://github.com/kiernann/metro/actions>
* r-hub: windows-x86_64-devel, ubuntu-gcc-release, fedora-clang-devel
  * <https://builder.r-hub.io/status/metro_1.0.0.tar.gz-7a275cee0ad148dea4c608d7a2270cdb>
  * <https://builder.r-hub.io/status/metro_1.0.0.tar.gz-542ca41f15f848a7a7b174486eeb06d0>
  * <https://builder.r-hub.io/status/metro_1.0.0.tar.gz-386073e9a0b744d992e9e60e1e2be34e>

Tests are run on both GitHub Actions and r-hub by supplying the API key as an
environment variable.

## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new release.

## Submission

* All functions require a valid free API key. A demo key can be found on the 
  [WMATA products page][demo]. Examples are not run. Tests are skipped if a key
  is not found as an environmental variable named `WMATA_KEY`.
  
[demo]: https://developer.wmata.com/products/5475f236031f590f380924ff
