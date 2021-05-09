# INSTALL

Declare docker compose version, for example

$ export DOCKER_COMPOSE_VERSION="1.29.1"

Then pull the image.
The image has docker compose script inside in the folder /@compose_script. To install just copy it from the image in your PATH, i use ~/bin

$ docker pull ptrn2l2/docker-compose-arm:${DOCKER_COMPOSE_VERSION}
$ mkdir -p ~/bin
$ docker container run -it --rm -v ~/.:/loc --name dc_scanc ptrn2l2/docker-compose-arm:${DOCKER_COMPOSE_VERSION} cp /@compose_script/docker-compose-$DOCKER_COMPOSE_VERSION.sh /loc/bin
$ ln -s ~/bin/docker-compose-$DOCKER_COMPOSE_VERSION.sh ~/bin/docker-compose
$ docker-compose --version

To build your own fork/download build assets from https://github.com/ptrn2l2/docker-compose-buildx-docker-image


