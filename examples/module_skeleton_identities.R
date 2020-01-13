library(outsider)

# build file structure for an example module
module_path <- module_skeleton(program_name = "goldenhind",
                               repo_user = "drake_on_github",
                               docker_user = "drake_on_docker",
                               full_name = 'Sir Francis Drake',
                               email = 'f.drake@goldenhind.gov.uk',
                               service = 'github',
                               flpth = tempdir())
# new path created 
(module_path)
# check the generated names and links
module_identities(flpth = module_path)
# check the files are in the right locations
module_check(flpth = module_path)
# deliberately break: delete a folder and check again
unlink(x = file.path(module_path, 'inst'), recursive = TRUE, force = TRUE)
module_check(flpth = module_path)

# clean-up
unlink(x = module_path, recursive = TRUE, force = TRUE)
