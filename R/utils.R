
pkgnm_get <- function(flpth) {
  info <- devtools::as.package(x = flpth)
  info[['package']]
}

tags_get <- function(flpth) {
  list.files(file.path(flpth, 'inst', 'dockerfiles'))
}

examples_get <- function(flpth) {
  flpth <- file.path(flpth, 'examples')
  file.path(flpth, list.files(flpth))
}

yaml_get <- function(flpth) {
  yaml::read_yaml(file.path(flpth, 'inst', 'om.yml'))
}

description_get <- function(flpth) {
  flpth <- file.path(flpth, 'DESCRIPTION')
  if (!file.exists(flpth)) {
    stop('Invalid R package path provided: No DESCRIPTION', call. = FALSE)
  }
  lines <- readLines(con = flpth)
  lines <- strsplit(x = lines, split = ':')
  pull <- vapply(X = lines, FUN = length, FUN.VALUE = integer(1)) == 2
  lines <- lines[pull]
  nms <- vapply(X = lines, FUN = '[[', FUN.VALUE = character(1), 1)
  nms <- trimws(nms)
  vals <- vapply(X = lines, FUN = '[[', FUN.VALUE = character(1), 2)
  vals <- trimws(vals)
  names(vals) <- nms
  vals
}

# @name fnames_get
# @title Function names for module
# @description Return function names of all available functions for an
# installed outsider modules
# @param repo Module repo
# @return character vector
# @family private
# fnames_get <- function(repo) {
#   pkgnm <- outsider:::pkgnm_guess(repo = repo)
#   ns <- suppressMessages(loadNamespace(pkgnm))
#   ls(ns)
# }

#' @name pkgdetails_get
#' @title Read the package description
#' @description Return a list of all package details based on a package's
#' DESCRIPTION file.
#' @param flpth Path to package
#' @return logical
#' @family private
pkgdetails_get <- function(flpth) {
  res <- list()
  res[['description']] <- as.list(description_get(flpth = flpth))
  res[['yaml']] <- yaml_get(flpth = flpth)
  res[['tags']] <- tags_get(flpth = flpth)
  res
}

#' @name templates_get
#' @title Retrieve template files
#' @description Return template files for an outsider module.
#' @return character vector
#' @family private
templates_get <- function() {
  fls <- list.files(path = system.file("extdata", package = "outsider"),
                    pattern = 'template_')
  templates <- vector(mode = 'list', length = length(fls))
  destpths <- sub(pattern = 'template_', replacement = '', x = fls)
  destpths <- gsub(pattern = '_', replacement = .Platform$file.sep,
                   x = destpths)
  for (i in seq_along(fls)) {
    flpth <- system.file("extdata", fls[[i]], package = "outsider")
    templates[[i]] <- paste0(readLines(con = flpth), collapse = '\n')
  }
  names(templates) <- destpths
  templates
}

#' @name string_replace
#' @title Replace patterns in a string
#' @description For a given character string, replace patterns with values.
#' @return character
#' @param string Text
#' @param patterns Patterns to replace with values
#' @param values Values to be put in place
#' @family private
string_replace <- function(string, patterns, values) {
  for (i in seq_along(values)) {
    string <- gsub(pattern = patterns[[i]], replacement = values[[i]],
                   x = string)
  }
  string
}

#' @name file_create
#' @title Create file
#' @description Write x to a filepath. Forces creation of directories.
#' @param x Text for writing to file
#' @param flpth File path to be created
#' @return NULL
#' @family private
file_create <- function(x, flpth) {
  basefl <- basename(path = flpth)
  dirpth <- sub(pattern = basefl, replacement = '', x = flpth)
  suppressWarnings(dir.create(path = dirpth, recursive = TRUE))
  write(x = x, file = flpth)
}
