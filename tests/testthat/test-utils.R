context('Testing \'utils\'')
# test_that('fnames_get() works', {
#   res <- with_mock(
#     `outsider.devtools:::repo_to_pkgnm` = function(...) 'outsider',
#     outsider.devtools:::fnames_get(repo = '')
#   )
#   expect_true('module_install' %in% res)
# })
flpth <- system.file('extdata', 'om..hello.world', package = 'outsider.base')
test_that('pkgnm_get() works', {
  expect_equal(outsider.devtools:::pkgnm_get(flpth), 'om..hello.world')
})
test_that('tags_get() works', {
  expect_true('latest' %in% outsider.devtools:::tags_get(flpth))
})
test_that('examples_get() works', {
  expect_true(file.exists(outsider.devtools:::examples_get(flpth)))
})
test_that('yaml_get() works', {
  expect_true(is.list(outsider.devtools:::yaml_get(flpth)))
})
test_that('description_get() works', {
  expect_true('Title' %in% names(outsider.devtools:::description_get(flpth)))
})
test_that('pkgdetails_get() works', {
  res <- outsider.devtools:::pkgdetails_get(flpth = flpth)
  expect_true('description' %in% names(res))
  expect_true('yaml' %in% names(res))
  expect_true('tags' %in% names(res))
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
  outsider.devtools:::file_create(x = 'test', flpth = flpth, overwrite = TRUE)
  expect_true(file.exists(flpth))
  unlink(x = 'dir1', recursive = TRUE, force = TRUE)
})

