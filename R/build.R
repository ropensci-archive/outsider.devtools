
#' @name module_skeleton
#' @title Generate a skeleton for a module
#' @description Create all the base files and folders to kickstart the
#' development of a new outsider module. Returns file path to new module.
#' @param flpth File path to location of where module will be created, default
#' current working directory.
#' @param program_name Name of the command-line program.
#' @param repo_user Developer's username for code sharing service. If NULL, no
#' code sharing site information is added.
#' @param docker_user Developer's username for Docker. If NULL, no docker 
#' information is added.
#' @param module_name Name of the module, if NULL rendered as
#' "om..[program_name]"
#' @param cmd Command-line call for program, default [program_name]
#' @param service Code-sharing site.
#' @return Character
#' @family build
#' @export
module_skeleton <- function(program_name, repo_user = NULL, docker_user = NULL,
                            flpth = getwd(), module_name = NULL,
                            cmd = program_name, service = c('github', 'gitlab',
                                                            'bitbucket')) {
  service <- match.arg(service)
  if (is.null(module_name)) {
    mdlnm <- paste0('om..', gsub(pattern = '[^a-zA-z0-9\\.]', replacement = '.',
                                 x = program_name))
    
    gsub(pattern = '[^a-zA-z0-9\\.]', replacement = '.', x = 'a)*.z')
  } else {
    if (grepl(pattern = '[a-zA-z0-9\\.]', x = module_name)) {
      stop(paste0('Special characters not allowed in ',  char('module_name')),
           call. = FALSE)
    }
    mdlnm <- module_name
  }
  r_version <- paste0(version[['major']], '.', version[['minor']])
  if (!dir.exists(file.path(flpth, mdlnm))) {
    dir.create(file.path(flpth, mdlnm))
  }
  package_name <- paste0(mdlnm)
  if (is.null(docker_user)) {
    docker_info <- '#docker: '
  } else {
    docker_info <- paste0('docker: ', docker_user)
  }
  if (is.null(repo_user)) {
    repo_info <- '#github:\n#url:'
    repo <- package_name
  } else {
    url <- switch(service, github = paste0('https://github.com/', repo_user,
                                           '/', package_name),
                  gitlab = paste0('https://gitlab.com/', repo_user,
                                  '/', package_name),
                  bitbucket = paste0('https://bitbucket.org/', repo_user,
                                     '/', package_name))
    repo_info <- paste0(service, ': ', repo_user, '\nurl: ', url)
    repo <- paste0(repo_user, '/', package_name)
  }
  values <- mget(c('repo_info', 'package_name', 'r_version', 'docker_info',
                   'program_name', 'cmd', 'repo'))
  patterns <- paste0('%', names(values), '%')
  templates <- templates_get()
  for (i in seq_along(templates)) {
    x <- string_replace(string = templates[[i]], patterns = patterns,
                        values = values)
    file_create(x = x, flpth = file.path(flpth, mdlnm, names(templates)[[i]]))
  }
  file.path(flpth, mdlnm)
}

#' @name module_travis
#' @title Generate Travis-CI file (GitHub only)
#' @description Write .travis.yml to working directory.
#' @details Validated outsider modules must have a .travis.yml in their
#' repository. These .travis.yml are created with \link{module_skeleton} but
#' can also be generated using this function.
#' @param flpth Directory in which to create .travis.yml
#' @return Logical
#' @family build
#' @export
module_travis <- function(flpth = getwd()) {
  travis_flpth <- system.file("extdata", 'template_.travis.yml',
                              package = "outsider.devtools")
  travis_text <- paste0(readLines(travis_flpth), collapse = '\n')
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
#' @family build
#' @export
module_identities <- function(flpth = getwd()) {
  res <- list()
  pkg_details <- pkgdetails_get(flpth = flpth)
  pkgnm <- pkg_details[['description']][['Package']]
  docker_user <- pkg_details[['yaml']][['docker']]
  res[['R package name']] <- pkgnm
  res[['URL']] <- pkg_details[['yaml']][['url']]
  img <- gsub(pattern = '\\.+', replacement = '_', x =  pkgnm)
  res[['Docker images']] <- paste0(docker_user, '/', img, ':',
                                   pkg_details[['tags']])
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
#' @description Returns TRUE if all the names and structure of a minimal viable
#' outsider module are correct.
#' @param flpth File path to location of module
#' @return Logical
#' @family build
#' @export
#' @example examples/module_build.R
module_check <- function(flpth = getwd()) {
  msg <- function(res, x) {
    if (res) {
      msg <- paste0(x, ' found ', cli::symbol[['tick']])
      cat_line(crayon::green(msg))
    } else {
      msg <- paste0(x, ' not found ', cli::symbol[['cross']])
      cat_line(crayon::red(msg))
    }
  }
  fls <- list.files(flpth)
  res1 <- 'DESCRIPTION' %in% fls
  msg(res1, 'DESCRIPTION')
  res2 <- length(list.files(file.path(flpth, 'R'))) > 1
  msg(res2, 'R folder with files')
  res3 <- 'inst' %in% fls
  msg(res3, 'inst')
  fls <- list.files(file.path(flpth, 'inst'))
  res4 <- 'om.yml' %in% fls
  msg(res4, file.path('inst', 'om.yml'))
  yaml::read_yaml(file.path(flpth, 'inst', 'om.yml'))
  res5 <- 'dockerfiles' %in% fls
  msg(res5, file.path('inst', 'dockerfiles'))
  fls <- list.files(file.path(flpth, 'inst', 'dockerfiles'))
  res6 <- rep(FALSE, length(fls))
  for (i in seq_along(fls)) {
    dckrfl <- list.files(file.path(flpth, 'inst', 'dockerfiles', fls[[i]]))
    res6[i] <- length(dckrfl) == 1 && dckrfl == 'Dockerfile'
    msg(res6[i], paste0(file.path('inst', 'dockerfiles', fls[i]), ' with one ',
                        'Dockerfile'))
  }
  res6 <- all(res6)
  invisible(res1 & res2 & res3 & res4 & res5 & res6)
}

#' @name module_build
#' @title Build a module
#' @description Do
#' @param flpth File path to location of module.
#' @param tag Docker tag, e.g. latest.
#' @param build_documents Build R documentation? T/F
#' @param build_package Build R package? T/F
#' @param build_image Build Docker image? T/F
#' @param verbose Be verbose? T/F
#' @return Logical
#' @family build
#' @export
#' @example examples/module_build.R
module_build <- function(flpth = getwd(), tag = NULL, build_documents = TRUE,
                         build_package = TRUE, build_image = TRUE,
                         verbose = TRUE) {
  if (build_image & is.null(tag)) {
    stop(paste0(char('tag'), ' must be provided if ', char('build_image'),
                ' is TRUE'))
  }
  if (build_documents) {
    cat_line(cli::rule())
    cat_line('Running ', func('devtools::document'), ' ...')
    cat_line(cli::rule())
    devtools::document(pkg = flpth)
  }
  if (build_package) {
    cat_line(cli::rule())
    cat_line('Running ', func('devtools::install'), ' ...')
    cat_line(cli::rule())
    devtools::install(pkg = flpth, upgrade = 'never', quiet = !verbose)
  }
  if (build_image) {
    tags <- tags_get(flpth = flpth)
    if (!tag %in% tags) {
      stop('No Dockerfile found for tag: ', paste0(char(tag)), call. = FALSE)
    }
    pkgnm <- pkgnm_get(flpth = flpth)
    if (!outsider.base::is_installed(pkgnm = pkgnm)) {
      stop(paste0(char(pkgnm), ' is not an installed R package. Try ',
                  char('build_package = TRUE')))
    }
    info <- outsider.base::meta_get(pkgnm = pkgnm)
    img <- info[['image']]
    dockerfile <- system.file('dockerfiles', tag, package = pkgnm)
    cat_line(cli::rule())
    cat_line('Running ', func('docker_build'))
    cat_line(cli::rule())
    docker_build(img = img, tag = tag, url_or_path = dockerfile,
                 verbose = verbose)
  }
}

#' @name module_test
#' @title Test an outsider module
#' @description Ensure an outsider module builds, imports correctly and all
#' its functions successfully complete.
#' @details Success or fail, the module is uninstalled from the machine after
#' the test is run.
#' @param flpth File path to location of module
#' @param verbose Print docker and program info to console
#' @param pull Pull image from Docker Hub? T/F
#' @return Logical
#' @family build
#' @export
#' @example examples/module_test.R
module_test <- function(flpth = getwd(), verbose = FALSE, pull = FALSE) {
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
  res <- withr::with_options(new = temp_opts, code = test(flpth = flpth,
                                                          pull = pull))
  invisible(res)
}

#' @name module_upload
#' @title Upload a module to code sharing site and DockerHub
#' @description Look up usernames and other information contained in
#' "om.yml" to upload module to a code sharing site (github, gitlab or
#' bitbucket) and/or DockerHub.
#' @param flpth File path to location of module
#' @param code_sharing Upload to code sharing service?
#' @param dockerhub Upload to DockerHub?
#' @param verbose Print docker and program info to console
#' @return Logical
#' @family build
#' @export
module_upload <- function(flpth = getwd(), code_sharing = TRUE,
                          dockerhub = TRUE, verbose = TRUE) {
  pkgnm <- pkgnm_get(flpth = flpth)
  if (!outsider.base::is_installed(pkgnm = pkgnm)) {
    stop(paste0(char(pkgnm), ' is not an installed R package.'))
  }
  meta <- outsider.base::meta_get(pkgnm = pkgnm)
  if (code_sharing) {
    services <- c('github', 'gitlab', 'bitbucket')
    pull <- services %in% names(meta)
    if (sum(pull) == 0) {
      stop('Unable to upload to a code-sharing serice',
           '. No github/gitlab/bitbucket username in module metadata.')
    }
    service <- services[services %in% names(meta)][[1]]
    username <- meta[[service]]
    cat_line(cli::rule())
    cat_line('Running ', func('git_upload'))
    cat_line(cli::rule())
    git_upload(flpth = flpth, username = username, service = service)
  }
  if (dockerhub) {
    username <- meta[['docker']]
    if (is.null(username)) {
      stop('Unable to upload to Docker-Hub.',
           '. No docker username in module metadata.')
    }
    img <- meta[['image']]
    avl_imgs <- outsider.base::docker_img_ls()
    tag <- avl_imgs[['tag']][avl_imgs[['repository']] == img]
    if (length(tag) == 0) {
      stop(paste0('No docker image found for ', char(pkgnm)))
    }
    cat_line(cli::rule())
    cat_line('Running ', func('docker_push'))
    cat_line(cli::rule())
    docker_push(username = username, img = img, tag = tag, verbose = verbose)
  }
}
