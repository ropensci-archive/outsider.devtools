test_that('remote_git_exists() works', {
  url <- 'https://github.com/dombennett/om..hello.world.git'
  expect_true(outsider.devtools:::remote_git_exists(url = url))
})
test_that('git_upload() works', {
  flpth <- 'test_git_upload'
  dir.create(flpth)
  # R package file
  file.create(file.path(flpth, 'DESCRIPTION'))
  on.exit(unlink(x = flpth, recursive = TRUE, force = TRUE))
  with_mock(
    `outsider.devtools:::pkgnm_get` = function(flpth) 'om..testing.git',
    `outsider.devtools:::remote_git_exists` = function(remote_url) TRUE,
    `git2r::cred_user_pass` = function(...) TRUE,
    `git2r::commit` = function(...) TRUE,
    `git2r::push` = function(...) TRUE,
    expect_true(git_upload(flpth = flpth, username = 'test_user'))
  )
})

