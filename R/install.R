install <- function(repo, tag, dockerfile_url = NULL) {
  success <- FALSE
  on.exit(expr = {
    if (!success) {
      uninstall(repo = repo)
    }
  })
  devtools::install_github(repo = repo, quiet = TRUE)
  if (is_installed(repo = repo)) {
    img <- repo_to_img(repo)
    if (is.null(dockerfile_url)) {
      success <- docker_pull(img = img, tag = tag)
    }
    else {
      success <- docker_build(img = img, url_or_path = dockerfile_url, 
                              tag = tag)
    }
  }
  invisible(success)
}

uninstall <- function(repo) {
  pkgnm <- repo_to_pkgnm(repo)
  if (pkgnm %in% devtools::loaded_packages()$package) {
    try(expr = devtools::unload(devtools::inst(pkgnm)), silent = TRUE)
  }
  if (is_installed(repo = repo)) {
    try(docker_img_rm(img = repo_to_img(repo = repo)), silent = TRUE)
    pkg_rm(pkgs = pkgnm)
  }
  invisible(!is_installed(repo = repo))
}

is_installed <- function(repo) {
  pkgnm <- repo_to_pkgnm(repo = repo)
  installed <- installed_pkgs()
  pkgnm %in% installed
}

installed_pkgs <- function(...) {
  utils::installed.packages(...)
}

pkg_rm <- function(...) {
  suppressMessages(utils::remove.packages(...))
}