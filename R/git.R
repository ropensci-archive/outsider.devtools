#' @name remote_git_exists
#' @title Does a remote git repo exist
#' @description Return TRUE if request returns a 200 status code.
#' @details Private repositories will not be discovered. Doesn't work for
#' bitbucket.
#' @param url URL to check
#' @return Logical
#' @family git
# TODO: why not working for bitbucket?
# 'https://bitbucket.org/dominicjbennett/om..hello.world.git' -- 400 code
remote_git_exists <- function(url) {
  res <- tryCatch(expr = {
    httr::HEAD(url = url)[['status_code']] == 200
    }, error = function(e) {
      FALSE 
    }, warning = function(e) {
      FALSE
    })
  res
}

#' @name git_upload
#' @title Upload module to code-sharing service
#' @description Upload module to a git-based code-sharing service. Initiate
#' a git repo, add core module files, commit and push to remote.
#' @details Remote URL is determined to be: code sharing URL + username + R
#' package name.
#' @param flpth File path to module.
#' @param username Username for code-sharing service.
#' @param service Code-sharing service
#' @return Logical
#' @family git
#' @export
git_upload <- function(flpth, username, service = c('github', 'gitlab',
                                                    'bitbucket')) {
  repo <- file.path(flpth, '.git')
  if (!dir.exists(repo)) {
    git2r::init(path = flpth)
    service <- match.arg(service)
    service_url <- switch(service, github = 'https://github.com/',
                          gitlab = 'https://gitlab.com/',
                          bitbucket = 'https://bitbucket.org/')
    url <- paste0(service_url, username, '/', pkgnm_get(flpth = flpth), '.git')
    git2r::remote_add(repo = repo, name = 'origin', url = url)
  }
  git2r::add(repo = repo, path = c('DESCRIPTION', 'examples', 'inst', 'man',
                                   'NAMESPACE', 'R', 'README.md',
                                   '.travis.yml'))
  status <- git2r::status(repo = repo)
  if (length(status[['staged']]) > 0) {
    git2r::commit(repo = repo, message = 'Commit from `module_upload()`')
  }
  remote_url <- git2r::remote_url(repo = repo, remote = 'origin')
  if (!remote_git_exists(remote_url)) {
    msg <- paste0('No repository found at: ', char(remote_url),
                  '\nDid you remember to create it online?')
    stop(msg, call. = FALSE)
  }
  msg <- paste0('Pushing to \'', remote_url, '\'\nPassword:')
  cred <- git2r::cred_user_pass(username = username,
                                password = getPass::getPass(msg = msg))
  git2r::push(object = repo, name = 'origin', set_upstream = TRUE,
              refspec = "refs/heads/master", credentials = cred)
  invisible(TRUE)
}
