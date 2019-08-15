
#' @name module_skeleton
#' @title Generate a skeleton for a module
#' @description Create all the base files and folders to kickstart the
#' development of a new outsider module.
#' @details Module developers must have a GitHub and Docker-Hub account.
#' For more detailed information, see online.
#' @param flpth File path to location of where module will be created, default
#' current working directory.
#' @param program_name Name of the command-line program
#' @param github_user Developer's username for GitHub
#' @param docker_user Developer's username for Docker
#' @return Logical
#' @export
module_skeleton <- function(program_name, github_user, docker_user,
                            flpth = getwd()) {
  r_version <- paste0(version[['major']], '.', version[['minor']])
  mdlnm <- paste0('om..', program_name)
  if (!dir.exists(file.path(flpth, mdlnm))) {
    dir.create(file.path(flpth, mdlnm))
  }
  package_name <- paste0(mdlnm, '..', github_user)
  repo <- paste0(github_user, '/', mdlnm)
  values <- mget(c('repo', 'package_name', 'r_version', 'docker_user',
                   'github_user', 'program_name'))
  patterns <- paste0('%', names(values), '%')
  templates <- templates_get()
  for (i in seq_along(templates)) {
    x <- string_replace(string = templates[[i]], patterns = patterns,
                        values = values)
    file_create(x = x, flpth = file.path(flpth, mdlnm, names(templates)[[i]]))
  }
  invisible(TRUE)
}

#' @name module_travis
#' @title Generate Travis-CI file
#' @description Write .travis.yml to working directory.
#' @details All validated outsider modules must have a .travis.yml in their
#' repository. These .travis.yml must be generated using this function.
#' @param repo Repository
#' @param flpth Directory in which to create .travis.yml
#' @return Logical
#' @export
module_travis <- function(repo, flpth = getwd()) {
  url <- paste0('https://raw.githubusercontent.com/DomBennett/',
                'om..hello.world/master/.travis.yml')
  travis_text <- paste0(readLines(url), collapse = '\n')
  travis_text <- sub(pattern = 'DomBennett/om\\.\\.hello\\.world',
                     replacement = repo, x = travis_text, ignore.case = TRUE)
  write(x = travis_text, file = file.path(flpth, '.travis.yml'))
  invisible(file.exists(file.path(flpth, '.travis.yml')))
}

#' @name module_identities
#' @title Return identities for a module
#' @description Returns a list of the identities (GitHub repo, Package name,
#' Docker images) for an outsider module. Works for modules in development.
#' Requires module to have a file path.
#' @param flpth File path to location of module
#' @return Logical
#' @export
module_identities <- function(flpth) {
  res <- list()
  pkg_details <- pkgdetails_get(flpth = flpth)
  pkgnm <- pkg_details[['description']][['Package']]
  docker_user <- pkg_details[['yaml']][['docker']]
  res[['R package name']] <- pkgnm
  res[['URL']] <- pkg_details[['yaml']][['url']]
  img <- gsub(pattern = '\\.+', replacement = '_', x =  pkgnm)
  res[['Docker images']] <- paste0(pkg_details[['yaml']][['docker']], '/',
                                   img, ':', pkg_details[['tags']])
  structure(res, class = 'identities')
}
#' @export
print.identities <- function(x, ...) {
  for (i in seq_along(x)) {
    msg <- names(x)[[i]]
    if (length(x[[i]]) == 1) {
      cat_line(msg, ': ', char(x[[i]]))
    } else {
      cat_line(msg, ' ... ')
      for (j in seq_along(x[[i]])) {
        msg <- names(x[[i]])[[j]]
        cat_line('... ', msg, ': ', char(x[[i]][[j]]))
      }
    }
  }
}

#' @name module_check
#' @title Check names and structure of a module
#' @description Returns TRUE if all the names and structure of an outsider
#' module are correct.
#' @param flpth File path to location of module
#' @return Logical
#' @export
#' @example examples/module_build.R
module_check <- function(flpth = NULL) {
  TRUE
}

#' @name module_test
#' @title Test an outsider module
#' @description Ensure an outsider module builds, imports correctly and all
#' its functions successfully complete.
#' @details Success or fail, the module is uninstalled from the machine after
#' the test is run.
#' @param flpth File path to location of module
#' @param verbose Print docker and program info to console
#' @return Logical
#' @export
#' @example examples/module_test.R
module_test <- function(flpth = getwd(), verbose = FALSE) {
  res <- FALSE
  on.exit(expr = {
    if (res) {
      celebrate()
    } else {
      comfort()
    }})
  if (verbose) {
    temp_opts <- list(program_out = TRUE, program_err = TRUE,
                      docker_out = TRUE, docker_err = TRUE)
  } else {
    temp_opts <- list(program_out = FALSE, program_err = FALSE,
                      docker_out = FALSE, docker_err = FALSE)
  }
  res <- withr::with_options(new = temp_opts, code = test(flpth = flpth))
  invisible(res)
}
