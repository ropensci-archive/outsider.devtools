
Development tools package for `outsider` <img src="https://raw.githubusercontent.com/AntonelliLab/outsider.devtools/master/logo_inverse.png" height="200" align="right"/>
----

[![Build Status](https://travis-ci.org/AntonelliLab/outsider.devtools.svg?branch=master)](https://travis-ci.org/AntonelliLab/outsider.base) [![AppVeyor build status](https://ci.appveyor.com/api/projects/status/github/AntonelliLab/outsider.devtools?branch=master&svg=true)](https://ci.appveyor.com/project/DomBennett/outsider.devtools) [![Coverage Status](https://coveralls.io/repos/github/AntonelliLab/outsider.devtools/badge.svg?branch=master)](https://coveralls.io/github/AntonelliLab/outsider.devtools?branch=master)

## Build [`outsider`](https://github.com/AntonelliLab/outsider#install-and-run-programs-outside-of-r-inside-of-r-) modules!

This package aims to make it easier for `outsider` module developers to make
their own modules. Build a module skeleton, check the file structures,
test the module and upload it online.

## Install

The `outsider` packages are all available via GitHub.

```r
# install.packages("remotes")
# requires outsider.base, outsider
remotes::install_github("AntonelliLab/outsider.base")
remotes::install_github("AntonelliLab/outsider")
remotes::install_github("AntonelliLab/outsider.devtools")
```

## Quick guide

Build an `outsider` module to run `echo` via Ubuntu in just a few function calls.

```r
# make my own quick package
library(outsider.devtools)
# construct a skeleton file structure for the module
module_path <- module_skeleton(program_name = 'echo', flpth = getwd())
# check the file structure
module_check(flpth = module_path)
# look-up key identifying names: R package name, Docker image name
module_identities(flpth = module_path)
# build the R package and Docker image
module_build(flpth = module_path, tag = 'latest')
# test the module
module_test(flpth = module_path)
```

Visit the webpage ["Getting started"](https://antonellilab.github.io/outsider.devtools/articles/outsider.devtools.html) to find out more.

## How do the `outsider` packages interact?

![](https://raw.githubusercontent.com/AntonelliLab/outsider.devtools/master/package_structures.png)

## Maintainer

[Dom Bennett](https://github.com/dombennett/)

