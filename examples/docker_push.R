library(outsider.devtools)

# NOT RUN
# # create image from om..echo Docker file
# url <- paste0('https://raw.githubusercontent.com/DomBennett/om..hello.world/',
#               'master/inst/dockerfiles/latest/Dockerfile')
# docker_build(img = 'test_docker_push', tag = 'latest', verbose = TRUE,
#              url_or_path = url)
# # push to your Docker Hub
# docker_push(username = '[YOUR USERNAME]', img = 'test_docker_push',
#             tag = 'latest', verbose = TRUE)
