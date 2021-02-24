## Test environments

* local: ubuntu-20.04 (release)
* github actions: ubuntu-20.04 (release, devel)
  * <https://github.com/kiernann/metro/actions>
* github actions: macOS-latest (release)
* github actions: windows-latest (release) 
* r-hub: windows-x86_64-devel, ubuntu-gcc-release, fedora-clang-devel
  * <https://builder.r-hub.io/status/metro_1.0.0.tar.gz-d6786502cfaf46f6809077ace1c94950>
  * <https://builder.r-hub.io/status/metro_1.0.0.tar.gz-be007c3022ad469cbf9168fba6a6d679>
  * <https://builder.r-hub.io/status/metro_1.0.0.tar.gz-333d63da4a054a7abeea613d7c05d46a>

## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new release.

## Submission

* All functions require a valid free API key. A demo key can be found on the 
  [WMATA products page][demo]. Examples are not run. Tests are skipped if a key
  is not found as an environmental variable named `WMATA_KEY`.
  
[demo]: https://developer.wmata.com/products/5475f236031f590f380924ff
