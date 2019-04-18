# LIBS
library(outsider.devtools)
library(testthat)

# Vars ----
repo <- outsider.devtools:::vars_get('repo')
pkgnm <- outsider.devtools:::vars_get('pkgnm')
img <- outsider.devtools:::vars_get('img')
cntnr <- outsider.devtools:::vars_get('cntnr')
tag <- 'latest'

# RUNNING ----
context('Testing \'container\'')
test_that('container_init() works', {
  with_mock(
    `outsider.devtools:::ids_get` = function(...) c('img' = img, 'cntnr' = cntnr,
                                           'tag' = tag),
    expect_true(inherits(outsider.devtools:::container_init(pkgnm = pkgnm),
                         'container'))
  )
  with_mock(
    `outsider.devtools:::ids_get` = function(...) c('img' = img, 'cntnr' = cntnr,
                                           'tag' = tag),
    expect_true(inherits(outsider.devtools:::container_init(repo = repo),
                         'container'))
  )
  expect_error(outsider.devtools:::container_init())
})
test_that('run.container() works', {
  container <- structure(list(), class = 'container')
  with_mock(
    `outsider.devtools:::exec.container` = function(x, ...) TRUE,
    expect_true(outsider.devtools:::run.container(x = container, cmd = '', args = ''))
  )
  res <- with_mock(
    `outsider.devtools:::exec.container` = function(x, ...) stop(),
    outsider.devtools:::run.container(x = container, cmd = '', args = '')
  )
  expect_true(inherits(res, 'simpleError'))
})
test_that('print.container() works', {
   with_mock(
    `outsider.devtools:::ids_get` = function(...) c('img' = img, 'cntnr' = cntnr,
                                           'tag' = tag),
    `outsider.devtools:::status.container` = function(x, ...) 'This is a mock',
    container <- outsider.devtools:::container_init(pkgnm = pkgnm),
    expect_null(print(container))
  )
})
test_that('container methods work', {
  # set-up
  outsider.devtools:::docker_pull(img = img)
  container <- with_mock(
    `outsider.devtools:::ids_get` = function(...) c('img' = img, 'cntnr' = cntnr,
                                           'tag' = tag),
    outsider.devtools:::container_init(pkgnm = pkgnm)
  )
  # pull down
  on.exit(outsider.devtools:::docker_img_rm(img = img))
  # tests
  expect_true(outsider.devtools:::status.container(container) == 'Not running')
  expect_true(outsider.devtools:::start.container(container))
  expect_true(outsider.devtools:::exec.container(container, 'touch', 'file_to_return'))
  expect_true(outsider.devtools:::copy.container(container, rtrn = getwd()))
  expect_true(file.exists('file_to_return'))
  expect_true(file.remove('file_to_return'))
  expect_true(file.create('file_to_send'))
  expect_true(outsider.devtools:::copy.container(container, send = 'file_to_send'))
  expect_true(file.remove('file_to_send'))
  #expect_true(outsider.devtools:::exec(container, 'ls'))
  expect_true(outsider.devtools:::status.container(container) == 'Running')
  expect_true(outsider.devtools:::halt.container(container))
})
