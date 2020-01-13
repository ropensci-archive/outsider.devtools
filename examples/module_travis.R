library(outsider)

# a skeleton already comes with a .travis.yml
module_path <- module_skeleton(program_name = "goldenhind",
                               repo_user = "drake_on_github",
                               docker_user = "drake_on_docker",
                               service = 'github',
                               flpth = tempdir())
(file.exists(file.path(module_path, '.travis.yml')))
# but if it were deleted, needs updating or mistakenly edited ...
file.remove(file.path(module_path, '.travis.yml'))
# a new one can generated
module_travis(flpth = module_path)
