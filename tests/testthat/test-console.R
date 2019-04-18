# LIBS
library(outsider.devtools)
library(testthat)

# RUNNING
context('Testing \'console\'')
test_that('.onAttach() works', {
  expect_true(outsider.devtools:::.onAttach())
})
test_that('char() works', {
  expect_true(is.character(outsider.devtools:::char('char')))
})
test_that('stat() works', {
  expect_true(is.character(outsider.devtools:::stat('stat')))
})
test_that('cat_line() works', {
  expect_null(outsider.devtools:::cat_line('cat this'))
})
test_that('celebrate() works', {
  res <- lapply(1:10, function(x) outsider.devtools:::celebrate())
  expect_null(res[[1]])
})
test_that('comfort() works', {
  res <- lapply(1:10, function(x) outsider.devtools:::comfort())
  expect_null(res[[1]])
})
