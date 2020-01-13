# Private ----
#' @name docker_cmd
#' @title Send commands to Docker
#' @description Safely send commands to Docker. All commands are also echo'd.
#' @param args Vector of arguments for "docker" command. E.g. '--help'.
#' @param std_out Logical or file path
#' @param std_err Logical or file path
#' @return Logical
#' @family docker-private
docker_cmd <- function(args, std_out = TRUE, std_err = TRUE) {
  outsider.base::is_docker_available()
  cmd_args <- crayon::silver(paste0('docker ', paste(args, collapse = ' ')))
  cat_line(crayon::bold('Command:\n'), cmd_args)
  cat_line(crayon::silver(cli::rule(line = '.')))
  # run through callr
  callr_args <- list(args, std_out, std_err)
  res <- callr::r(func = function(args, std_out, std_err) {
    sys::exec_wait(cmd = 'docker', args = args,
                   std_out = std_out, std_err = std_err) 
  }, args = callr_args, show = TRUE)
  res == 0
}

#' @name docker_login
#' @title Login to Docker
#' @description Login to docker using username. User is prompted to provide
#' password.
#' Returns TRUE if no errors are raised.
#' @param username Username for Docker-Hub.
#' @return Logical
#' @family docker-private
docker_login <- function(username) {
  res <- sys::exec_internal(cmd = 'docker', args = 'login', error = FALSE)
  if (res[['status']] == 0) {
    return(invisible(TRUE))
  }
  psswrd_file <- tempfile()
  on.exit(file.remove(psswrd_file))
  msg <- paste0('Password for [', username, ']: ')
  write(x = getPass::getPass(msg = msg), file = psswrd_file)
  arglist <- c('login', '-u', username, '--password-stdin')
  res <- sys::exec_internal(cmd = 'docker', args = arglist,
                            std_in = psswrd_file)
  success <- res[['status']] == 0
  if (success) {
    cat_line('Successfully logged in as ', char(username))
  } else {
    cat_line('Login failed.')
  }
  invisible(success)
}

# Public ----
#' @name docker_build
#' @title Build a Docker image
#' @description Build a Docker image through a system call. Returns TRUE if
#' no errors are raised.
#' @param img Image name
#' @param tag Tag, e.g. 'latest'
#' @param url_or_path URL or file path to Dockerfile
#' @param verbose Be verbose? T/F
#' @return Logical
#' @family docker
#' @export
#' @example examples/docker_build.R
docker_build <- function(img, tag, url_or_path, verbose) {
  args <- c('build', '-t', paste0(img, ':', tag), url_or_path)
  docker_cmd(args = args, std_out = verbose, std_err = verbose)
}

#' @name docker_push
#' @title Push a Docker image to Docker Hub
#' @description Push a Docker image to Docker Hub. Requires a user to have login
#' details for Docker Hub, \url{https://hub.docker.com/}.
#' Returns TRUE if no errors are raised.
#' @param username Login username for Docker Hub.
#' @param img Image name
#' @param tag Tag, e.g. 'latest'
#' @param verbose Be verbose? T/F
#' @return Logical
#' @family docker
#' @export
#' @example examples/docker_push.R
docker_push <- function(username, img, tag, verbose) {
  if (!docker_login(username = username)) {
    stop(paste0('Unable to login to DockerHub with username ', char(username)),
         call. = FALSE)
  }
  args <- c('push', paste0(img, ':', tag))
  docker_cmd(args = args, std_out = verbose, std_err = verbose)
}
