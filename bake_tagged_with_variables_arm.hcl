# NOTE: on my version of buildx variable are not yet supported.
variable "DOCKER_COMPOSE_VERSION" {
  default = "1.26.2"
}
variable "DOCKER_HUB_USER" {
  default = "ptrn2l2"
}

group "default" {
  targets = ["docker_compose_arm"]
}

target "docker_compose_arm" {
  context = ".",
  dockerfile = "ptrn2l2_dc.Dockerfile",
  output = ["type=registry"],
  tags = ["${DOCKER_HUB_USER}/docker-compose-arm:${DOCKER_COMPOSE_VERSION}"],
  platforms = ["linux/armhf", "linux/arm64"]
}

# if you have configured buildx with multiple archs:
target "docker_compose" {
  context = ".",
  dockerfile = "ptrn2l2_dc.Dockerfile",
  output = ["type=registry"],
  tags = ["${DOCKER_HUB_USER}/docker-compose:${DOCKER_COMPOSE_VERSION}"],
  platforms = ["linux/amd64", "linux/armhf", "linux/arm64"]
}

