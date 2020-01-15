context('Test the basic skeleton pipeline')
test_that('om..echo can be built', {
  skip_if(!outsider.base::is_docker_available(call_error = FALSE))
  module_path <- module_skeleton(program_name = 'echo', flpth = getwd())
  on.exit(unlink(x = module_path, recursive = TRUE, force = TRUE))
  expect_true(module_check(flpth = module_path))
  expect_true(inherits(module_identities(flpth = module_path), 'identities'))
  # TODO: Can't build readme on traivs?
  with_mock(
    `devtools::build_readme` = function(...) TRUE,
    expect_true(module_build(flpth = module_path, tag = 'latest'))
  )
  expect_true(module_test(flpth = module_path))
  expect_true(outsider::module_uninstall('om..echo'))
})
