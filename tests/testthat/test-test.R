# LIBS
library(outsider.devtools)
library(testthat)

# RUNNING
context('Testing \'internal\'')
# test_that('fnames_get() works', {
#   res <- with_mock(
#     `outsider.devtools:::repo_to_pkgnm` = function(...) 'outsider',
#     outsider.devtools:::fnames_get(repo = '')
#   )
#   expect_true('module_install' %in% res)
# })
context('Testing \'test\'')
test_that('examples_test() works', {
  with_mock(
    `outsider.devtools:::examples_get` = function(...) 'foo.R',
    `outsider.devtools:::ex_source` = function(...) stop('Foo error'),
    expect_false(outsider.devtools:::examples_test(flpth = ''))
  )
  with_mock(
    `outsider.devtools:::examples_get` = function(...) 'foo.R',
    `outsider.devtools:::ex_source` = function(...) NULL,
    expect_true(outsider.devtools:::examples_test(flpth = ''))
  )
})
