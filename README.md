Tarantool Homebrew Tap
======================

This is [Homebrew][brew] tap or several versions of formulae for installing
[Tarantool][tnt] to different versions of Mac OSX systems.

TL;DR
-----
    brew tap tarantool/tap
    brew update
    brew install tarantool@2.6

Why there is yet another Homebrew formulae for Tarantool?
---------------------------------------------------------

There is already Tarantool formulae in the central [Homebrew-core][homebrew-core]
repository, so why we may need this Tap?

It's complicated. [Tarantool][tnt] supports [several versions of a product][releases]
at the same time, of different stability levels, e.g. [LTS, stable, beta][releases],
not saying there is actual development head. Unfortunately, you have to be very
large product, installed millions of installations, to make possible to keep several
versions of formulaes available in the Homebrew-core, e.g. at the momemnt of writing
Boost was available as 4 versions: `HEAD` (1.74), temporary alias 1.74, and older
versions - 1.57 and 1.60.
Moreover, Homebrew is not keeping all released versions, just only a fraction.

To have fuller control of that is available, for which product version and/or MacOSX
versions, you need to use vendor Tap.

Setup/Preparations
------------------

These formulaes use Homebrew, and will recompile installed project upon download,
so you have to install Xcode before.

This command will add this tap to the list of used Homebrew sources for installation:

    brew tap tarantool/tap

This is good practice before installing formula from central repository or from the
tap to update all definitions with:

    brew update

Usage
-----

To install formulae you usually run `brew install <productname>` with the name of
formula used for installation of productname. Formula name may include particular
version of product, e.g. `tarantool@1.10` if you want to install older version,
not the latest one.

So for installing of versions below, you need to run commands:

| Tarantool version | Command                                       |
|-------------------|-----------------------------------------------|
| 1.10              | `brew install tarantool@1.10`                 |
| 2.5               | `brew install tarantool@2.5`                  |
| 2.6               | `brew install tarantool@2.6`                  |
| _latest release_  | `brew install tarantool/tap/tarantool`        |
| _master_          | `brew install tarantool/tap/tarantool --HEAD` |


References
----------
`brew help`, `man brew` to see local Homebrew documentation.

[brew]: http://brew.sh
[homebrew-core]: https://github.com/Homebrew/homebrew-core/blob/master/Formula/tarantool.rb
[tnt]: http://tarantool.io
[releases]: https://www.tarantool.io/en/doc/latest/dev_guide/release_management/
