
Development tools package for `outsider` <img src="https://raw.githubusercontent.com/ropensci/outsider.devtools/master/other/logo_devtools.png" height="200" align="right"/>
----

[![Build Status](https://travis-ci.org/ropensci/outsider.devtools.svg?branch=master)](https://travis-ci.org/ropensci/outsider.base) [![AppVeyor build status](https://ci.appveyor.com/api/projects/status/github/ropensci/outsider.devtools?branch=master&svg=true)](https://ci.appveyor.com/project/DomBennett/outsider-devtools) [![Coverage Status](https://coveralls.io/repos/github/ropensci/outsider.devtools/badge.svg?branch=master)](https://coveralls.io/github/ropensci/outsider.devtools?branch=master) 
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.3615074.svg)](https://doi.org/10.5281/zenodo.3615074)

## Build [`outsider`](https://github.com/ropensci/outsider#readme) modules!

This package aims to make life easier for  those who wish to build their own
`outsider` modules. In just a few function calls: build a module skeleton,
check the file structures, test the module and upload it online!
Top banana! :banana:

Acquaint yourself better with all these steps by reading up on:

* ["Basic: Module Building"](https://docs.ropensci.org/outsider.devtools/articles/basic.html)
* ["Intermediate: Module Building"](https://docs.ropensci.org/outsider.devtools/articles/intermediate.html)
* ["Advanced: Module Building"](https://docs.ropensci.org/outsider.devtools/articles/advanced.html)

Happy building! :wrench:

## Install

Install via GitHub ....

```r
# install.packages("remotes")
remotes::install_github("ropensci/outsider.devtools")
```

In addition to installing `outsider.devtools`, the above code will also install
the key dependency packages
[`outsider.base`](https://github.com/ropensci/outsider.base#readme) and 
[`outsider`](https://github.com/ropensci/outsider#readme). (Read up on
[`remotes`](https://github.com/r-lib/remotes))

## Quick guide

Build an [`outsider`](https://github.com/ropensci/outsider#readme) module to run [`echo`](https://en.wikipedia.org/wiki/Echo_(command)) via the [Linux distribution Ubuntu](https://en.wikipedia.org/wiki/Ubuntu) in just a few function calls.

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

![](https://raw.githubusercontent.com/ropensci/outsider.devtools/master/other/build_example.gif)

Visit the webpage ["The Basics"](https://docs.ropensci.org/outsider.devtools/articles/basic.html) to find out more.

## How do the `outsider` packages interact?

![](https://raw.githubusercontent.com/ropensci/outsider.devtools/master/other/package_structures.png)

## Citation

Bennett et al. (2019). outsider: Install and run programs, outside of R, inside of R.
*Journal of Open Source Software*, *In review*

## Maintainer

[Dom Bennett](https://github.com/dombennett/)

---

[![ropensci_footer](https://ropensci.org/public_images/ropensci_footer.png)](https://ropensci.org)
