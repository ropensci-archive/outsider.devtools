

# Running ----
# test_that('test() works', {
#   tags <- tibble::as_tibble(list(repo = c('test/repo', 'test/repo'),
#                                  tag = c('latest', '1.0'),
#                                  download_url = c('test.com', 'test.com')))
#   with_mock(
#     `outsider.devtools:::uninstall` = function(...) TRUE,
#     `outsider.devtools:::examples_test` = function(...) TRUE,
#     `outsider.devtools:::import_test` = function(...) TRUE,
#     `outsider.devtools:::install_test` = function(...) TRUE,
#     `outsider.devtools:::tags` = function(...) tags,
#     expect_true(outsider.devtools:::test(repo = 'test/repo'))
#   )
#   with_mock(
#     `outsider.devtools:::uninstall` = function(...) TRUE,
#     `outsider.devtools:::examples_test` = function(...) FALSE,
#     `outsider.devtools:::import_test` = function(...) TRUE,
#     `outsider.devtools:::install_test` = function(...) TRUE,
#     `outsider.devtools:::tags` = function(...) tags,
#     expect_error(outsider.devtools:::test(repo = 'test/repo'))
#   )
#   with_mock(
#     `outsider.devtools:::uninstall` = function(...) TRUE,
#     `outsider.devtools:::examples_test` = function(...) TRUE,
#     `outsider.devtools:::import_test` = function(...) FALSE,
#     `outsider.devtools:::install_test` = function(...) TRUE,
#     `outsider.devtools:::tags` = function(...) tags,
#     expect_error(outsider.devtools:::test(repo = 'test/repo'))
#   )
#   with_mock(
#     `outsider.devtools:::uninstall` = function(...) TRUE,
#     `outsider.devtools:::examples_test` = function(...) TRUE,
#     `outsider.devtools:::import_test` = function(...) TRUE,
#     `outsider.devtools:::install_test` = function(...) stop(),
#     `outsider.devtools:::tags` = function(...) tags,
#     expect_error(outsider.devtools:::test(repo = 'test/repo'))
#   )
# })
# test_that('pkgdetails_get() works', {
#   drpth <- tempdir()
#   flpth <- file.path(drpth, 'DESCRIPTION')
#   write(x = description, file = flpth)
#   on.exit(file.remove(flpth))
#   res <- outsider.devtools:::pkgdetails_get(flpth = drpth)
#   expect_true(inherits(res, 'character'))
#   expect_error(outsider.devtools:::pkgdetails_get(flpth = 'notapath'))
# })
test_that('print.identities() works', {
  ids <- structure(list('this' = 'that', 'other' = list('a' = 'a', 'b' = 'b')),
                   class = 'identities')
  expect_null(outsider.devtools:::print.identities(ids))
})
test_that('templates_get() works', {
  res <- outsider.devtools:::templates_get()
  expect_true(inherits(res, 'list'))
})
test_that('string_replace() works', {
  string <- '%animal_1% are a lot better than %animal_2%'
  patterns <- c('%animal_1%', '%animal_2%')
  values <- c('sheep', 'cows')
  res <- outsider.devtools:::string_replace(string = string,
                                            patterns = patterns,
                                            values = values)
  expect_true(inherits(res, 'character'))
  expect_false(grepl(pattern = '%', x = res))
})
test_that('file_create() works', {
  flpth <- file.path('dir1', 'dir2', 'testfile')
  outsider.devtools:::file_create(x = 'test', flpth = flpth)
  expect_true(file.exists(flpth))
  unlink(x = 'dir1', recursive = TRUE, force = TRUE)
})
test_that('module_skeleton() works', {
  module_skeleton(program_name = 'newprogram', repo_user = 'ghuser',
                  docker_user = 'dhuser', service = 'github')
  expect_true(dir.exists('om..newprogram'))
  unlink(x = 'om..newprogram', recursive = TRUE, force = TRUE)
})
test_that('module_travis() works', {
  flpth <- file.path('travis_test', '.travis.yml')
  outsider.devtools:::file_create(x = '', flpth = flpth)
  expect_true(module_travis(flpth = 'travis_test'))
  unlink(x = 'travis_test', recursive = TRUE, force = TRUE)
})
test_that('module_identities() works', {
  module_skeleton(program_name = 'newprogram', repo_user = 'ghuser',
                  docker_user = 'dhuser', service = 'github')
  res <- module_identities(flpth = 'om..newprogram')
  unlink(x = 'om..newprogram', recursive = TRUE, force = TRUE)
  expect_true(inherits(res, 'identities'))
})
test_that('module_check() works', {
  module_skeleton(program_name = 'newprogram', repo_user = 'ghuser',
                  docker_user = 'dhuser', service = 'github')
  expect_true(module_check(flpth = 'om..newprogram'))
  unlink(x = 'om..newprogram', recursive = TRUE, force = TRUE)
})
test_that('module_test() works', {
  with_mock(
    `outsider.devtools:::test` = function(...) TRUE,
    expect_true(module_test(flpth = '', verbose = TRUE))
  )
  with_mock(
    `outsider.devtools:::test` = function(...) FALSE,
    expect_false(module_test(flpth = '', verbose = FALSE))
  )
})
