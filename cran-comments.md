## Test environments

* local R installation (Windows 11), R 4.5.2
* local R installation (macOS 11.4), R 4.5.2
* ubuntu-latest (on GitHub Actions), (oldrel-1, devel, and release)
* windows-latest (on GitHub Actions), (release)
* macOS-latest (on GitHub Actions), (release)
* Windows (on Winbuilder), (devel and release)

## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new release.

## Additional notes

* This package does contain code to interact with a user's directory but this only can occur if the user
  * opts into it by setting up environment variables to direct the package
  * by confirming suggested paths during an interactive session
