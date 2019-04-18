# LIBS
library(outsider.devtools)
library(testthat)

# RUNNING
context('Testing \'internal\'')
test_that('fnames_get() works', {
  res <- with_mock(
    `outsider.devtools:::repo_to_pkgnm` = function(...) 'outsider',
    outsider.devtools:::fnames_get(repo = '')
  )
  expect_true('module_install' %in% res)
})
context('Testing \'test\'')
# TODO: install() -- should it be part of devtools?
# test_that('install_test() works', {
#   with_mock(
#     `outsider:::install` = function(...) stop(''),
#     `outsider::module_uninstall` = function(...) FALSE,
#     expect_error(outsider.devtools:::install_test(repo = '', tag = 'latest'))
#   )
#   with_mock(
#     `outsider:::install` = function(...) TRUE,
#     `outsider::module_uninstall` = function(...) TRUE,
#     expect_true(outsider.devtools:::install_test(repo = '', tag = 'latest'))
#   )
# })
# TODO: module_import() -- should it be part of devtools?
# test_that('import_test() works', {
#   with_mock(
#     `outsider.devtools:::fnames_get` = function(...) 'foo',
#     `outsider::module_import` = function(...) NULL,
#     expect_false(outsider.devtools:::import_test(repo = ''))
#   )
#   with_mock(
#     `outsider.devtools:::fnames_get` = function(...) 'foo',
#     `outsider::module_import` = function(...) function() {},
#     expect_true(outsider.devtools:::import_test(repo = repo))
#   )
# })
test_that('examples_test() works', {
  with_mock(
    `outsider.devtools:::fnames_get` = function(...) 'foo',
    `outsider.devtools:::ex_source` = function(...) stop('Foo error'),
    expect_false(outsider.devtools:::examples_test(repo = ''))
  )
  with_mock(
    `outsider.devtools:::fnames_get` = function(...) 'foo',
    `outsider.devtools:::ex_source` = function(...) NULL,
    expect_true(outsider.devtools:::examples_test(repo = ''))
  )
})
context('Testing \'unittest\'')
test_that('datadir_get() works', {
  expect_true(grepl(pattern = 'data', x = outsider.devtools:::datadir_get()))
})
test_that('vars_get() works', {
  expect_true(grepl(pattern = 'hello', x = outsider.devtools:::vars_get('repo')))
})
