# make my own quick package
library(outsider.devtools)
flpth <- '/home/dom/Desktop'
module_path <- module_skeleton(program_name = 'echo', repo_user = 'dombennett',
                               docker_user = 'dombennett', flpth = flpth,
                               service = 'github')
module_check(flpth = module_path)
module_identities(flpth = module_path)
module_build(flpth = module_path, tag = 'latest')
module_test(flpth = module_path)
module_upload(flpth = module_path)
