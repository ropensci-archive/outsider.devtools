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
test_that('install_test() works', {
  with_mock(
    `outsider.devtools:::install` = function(...) stop(''),
    `outsider.devtools:::uninstall` = function(...) FALSE,
    expect_error(outsider.devtools:::install_test(repo = '', tag = 'latest'))
  )
  with_mock(
    `outsider.devtools:::install` = function(...) TRUE,
    `outsider.devtools:::uninstall` = function(...) TRUE,
    expect_true(outsider.devtools:::install_test(repo = '', tag = 'latest'))
  )
})
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
