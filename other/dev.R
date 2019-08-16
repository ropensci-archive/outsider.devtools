# make my own quick package
library(outsider.devtools)
flpth <- file.path(getwd(), 'other')
module_path <- module_skeleton(program_name = 'echo', repo_user = 'dombennett',
                               docker_user = 'dombennett', flpth = flpth,
                               service = 'github')
module_check(flpth = module_path)
module_identities(flpth = module_path)
module_build(flpth = module_path, tag = 'latest')
# TODO: make sure outsider modules with urls are discoverable by outsider
module_test(flpth = module_path)
module_upload(flpth = module_path)


docker_build(flpth = flpth)
docker_push(flpth = flpth)
