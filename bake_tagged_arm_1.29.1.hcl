# -------------------------------------------
# # don't use default buildx, it won't work!
# # Create a buildx context like:
# #         $ docker context use default
# #         $ docker builx create --name docker_desktop
# # or you'll have a "auto-push is currently not implemented for docker driver" error 
# -------------------------------------------
# docker context use default
# docker buildx use docker_desktop
# docker buildx ls
# docker buildx bake -f <hcl_file_name>>.hcl --print
group "default" {
  targets = ["docker_compose_arm"]
}

target "docker_compose_arm" {
  context = "."
  dockerfile = "ptrn2l2_dc.Dockerfile"
  output = ["type=registry"]
  tags = ["ptrn2l2/docker-compose-arm:1.29.1"]
  platforms = ["linux/armhf", "linux/arm64"]
}

# if you have configured buildx with multiple archs
#  - default in this hcl file is arm only to simplify build on arm pc -
# NOTE: on my version of buildx variable are not yet supported
#       so the following target won't work:
#target "docker_compose" {
#  context = "."
#  dockerfile = "ptrn2l2_dc.Dockerfile"
#  output = ["type=registry"]
#  tags = ["ptrn2l2/docker-compose:${DOCKER_COMPOSE_VERSION}"]
#  platforms = ["linux/amd64", "linux/armhf", "linux/arm64"]
#}

