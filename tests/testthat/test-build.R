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
test_that('print.identities() works', {
  ids <- structure(list('this' = 'that', 'other' = list('a' = 'a', 'b' = 'b')),
                   class = 'identities')
  expect_null(outsider.devtools:::print.identities(ids))
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
test_that('module_upload() works', {
  avl_imgs <- data.frame(tag = 'latest',
                         repository = 'test_image')
  meta <- list('github' = 'testuser', 'docker' = 'testuser',
               'image' = 'test_image')
  with_mock(
    `outsider.devtools:::pkgnm_get` = function(...) 'test-package',
    `outsider.base::is_installed` = function(...) TRUE,
    `outsider.base::meta_get` = function(...) meta,
    `outsider.devtools:::git_upload` = function(...) TRUE,
    `outsider.base:::docker_img_ls` = function(...) avl_imgs,
    `outsider.devtools:::docker_push` = function(...) TRUE,
    expect_true(module_upload(flpth = '', verbose = TRUE))
  )
  meta <- list('github' = 'testuser', 'docker' = 'testuser',
               'image' = 'absent_image')
  with_mock(
    `outsider.devtools:::pkgnm_get` = function(...) 'test-package',
    `outsider.base::is_installed` = function(...) TRUE,
    `outsider.base::meta_get` = function(...) meta,
    `outsider.devtools:::git_upload` = function(...) TRUE,
    `outsider.base:::docker_img_ls` = function(...) avl_imgs,
    `outsider.devtools:::docker_push` = function(...) TRUE,
    expect_error(module_upload(flpth = '', verbose = TRUE))
  )
  meta <- list('docker' = 'testuser', 'image' = 'test_image')
  with_mock(
    `outsider.devtools:::pkgnm_get` = function(...) 'test-package',
    `outsider.base::is_installed` = function(...) TRUE,
    `outsider.base::meta_get` = function(...) meta,
    `outsider.devtools:::git_upload` = function(...) TRUE,
    `outsider.base:::docker_img_ls` = function(...) avl_imgs,
    `outsider.devtools:::docker_push` = function(...) TRUE,
    expect_error(module_upload(flpth = '', verbose = TRUE))
  )
  meta <- list('github' = 'testuser', 'image' = 'test_image')
  with_mock(
    `outsider.devtools:::pkgnm_get` = function(...) 'test-package',
    `outsider.base::is_installed` = function(...) TRUE,
    `outsider.base::meta_get` = function(...) meta,
    `outsider.devtools:::git_upload` = function(...) TRUE,
    `outsider.base:::docker_img_ls` = function(...) avl_imgs,
    `outsider.devtools:::docker_push` = function(...) TRUE,
    expect_error(module_upload(flpth = '', verbose = TRUE))
  )
})
