context('Docker')
test_that('docker_cmd() works', {
  with_mock(
    `callr::r` = function(...) 0,
    expect_true(outsider.devtools:::docker_cmd(args = 'test'))
  )
})
test_that('docker_login() works', {
  with_mock(
    `sys::exec_internal` = function(...) list('status' = 0),
    `getPass::getPass` = function(...) 'password',
    expect_true(outsider.devtools:::docker_login(username = 'user'))
  )
})
# not really tests ....
test_that('docker_build() works', {
  with_mock(
    `outsider.devtools:::docker_cmd` = function(...) TRUE,
    expect_true(outsider.devtools::docker_build(img = '', tag = '',
                                                url_or_path = '', verbose = ''))
  )
})
test_that('docker_push() works', {
  with_mock(
    `outsider.devtools:::docker_cmd` = function(...) TRUE,
    `outsider.devtools:::docker_login` = function(...) TRUE,
    expect_true(outsider.devtools::docker_push(username = '', img = '',
                                               tag = '', verbose = TRUE))
  )
  with_mock(
    `outsider.devtools:::docker_cmd` = function(...) TRUE,
    `outsider.devtools:::docker_login` = function(...) FALSE,
    expect_error(outsider.devtools::docker_push(username = '', img = '',
                                                tag = '', verbose = TRUE))
  )
})
