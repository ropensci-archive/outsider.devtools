# Checks ----
#' @name is_docker_available
#' @title Check if Docker is available
#' @description Raises an error if Docker is not available.
#' @return NULL
#' @family private-check
is_docker_available <- function() {
  avlbl <- stevedore::docker_available(verbose = FALSE)
  if (!avlbl) {
    stop("Docker is not available.", call. = FALSE)
  }
  invisible(NULL)
}

# Base function ----
#' @name docker_cmd
#' @title Run docker command
#' @description Runs a docker command with provided arguments
#' @param args Vector of arguments
#' @param std_out if and where to direct child process STDOUT.
#' See \code{\link[sys]{exec}}.
#' @param std_err if and where to direct child process STDERR.
#' See \code{\link[sys]{exec}}.
#' @return Logical
#' @family private-docker
docker_cmd <- function(args, std_out = TRUE, std_err = TRUE) {
  is_docker_available()
  cl <- stevedore::docker_client()
  cl <- cl$container
  cntnr <- cl$create(image = "dombennett/om_mafft",
                     name = 'testing_stevedore')
  cntnr$status()
  inseq <- '/Users/djb208/Coding/sprmtrxR_demo/primates/clusters/sequences1.fasta'
  cntnr$cp_in(src = 'script', dest = 'working_dir')
  cntnr$cp_in(src = inseq, dest = 'working_dir')
  cntnr$start()
  cntnr$logs()
  cntnr$status()
  cntnr$cp_out(src = 'working_dir/outseq.fasta', dest = '.')
  cntnr$remove()
  
  
  cntnr$container$exec(cmd = 'ls')
  cntnr$container$exec_create(cmd = 'ls')
  cntnr$container$exec
  cntnr$container$remove()
  cntnr$container$image()
  cntnr$id()
  cntnr$rename(name = 'ubuntu_container')
  cntnr$inspect()
  cntnr$start
  cntnr$restart
  cntnr$remove()
  cntnr$status()
  cntnr$exec(cmd = "echo hello")
  
  cntnr$run
  
  exec(x = cntnr, cmd = )
  callr_args <- list(args, std_out, std_err)
  res <- callr::r(func = function(args, std_out, std_err) {
    sys::exec_wait(cmd = 'docker', args = args,
                   std_out = std_out, std_err = std_err) 
  }, args = callr_args, show = TRUE)
  res == 0
}
