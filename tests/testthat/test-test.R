context('Testing \'test\'')
test_that('test() works', {
  flpth <- system.file('extdata', 'om..hello.world', package = 'outsider.base')
  with_mock(
    `outsider.base:::pkg_install` = function(...) stop(),
    expect_error(outsider.devtools:::test(flpth = flpth, pull = FALSE))
  )
  with_mock(
    `outsider.base:::pkg_install` = function(...) TRUE,
    `outsider.base:::uninstall` = function(...) TRUE,
    `outsider.base:::image_install` = function(...) stop(),
    expect_error(outsider.devtools:::test(flpth = flpth, pull = FALSE))
  )
  with_mock(
    `outsider.base:::pkg_install` = function(...) TRUE,
    `outsider.base:::uninstall` = function(...) TRUE,
    `outsider.base:::image_install` = function(...) TRUE,
    `outsider.devtools:::examples_test` = function(...) FALSE,
    expect_error(outsider.devtools:::test(flpth = flpth, pull = FALSE))
  )
})
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
