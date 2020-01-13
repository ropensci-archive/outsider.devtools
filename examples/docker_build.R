library(outsider.devtools)

# simplest possible Dockerfile
df_text <- "
FROM ubuntu:latest
"

# create dir to host Dockerfile
flpth <- file.path(tempdir(), 'test_docker_build')
if(!dir.exists(flpth)) {
  dir.create(flpth)
}

# write to file
write(x = df_text, file = file.path(flpth, 'Dockerfile'))

# run docker_build from flpth
docker_build(img = 'test_docker_build', tag = 'latest', verbose = TRUE,
             url_or_path = flpth)
