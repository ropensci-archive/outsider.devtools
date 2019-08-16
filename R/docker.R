docker_cmd <- function(args, std_out = TRUE, std_err = TRUE) {
  outsider.base::is_docker_available()
  cmd_args <- crayon::silver(paste0('docker ', paste(args, collapse = ' ')))
  cat_line(crayon::bold('Command:\n'), cmd_args)
  # run through callr
  callr_args <- list(args, std_out, std_err)
  res <- callr::r(func = function(args, std_out, std_err) {
    sys::exec_wait(cmd = 'docker', args = args,
                   std_out = std_out, std_err = std_err) 
  }, args = callr_args, show = TRUE)
  res == 0
}

docker_build <- function(img, tag, url_or_path, verbose) {
  args <- c('build', '-t', paste0(img, ':', tag), url_or_path)
  docker_cmd(args = args, std_out = verbose, std_err = verbose)
}

docker_push <- function(img, tag, verbose) {
  args <- c('push', paste0(img, ':', tag))
  docker_cmd(args = args, std_out = verbose, std_err = verbose)
}

docker_login <- function(username) {
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
