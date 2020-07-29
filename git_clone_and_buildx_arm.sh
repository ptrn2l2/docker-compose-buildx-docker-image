#!/usr/bin/env bash
# Example:
# > export DOCKER_COMPOSE_VERSION=1.26.2
# > ./git_clone_and_buildx.sh
if [ -z "$DOCKER_COMPOSE_VERSION" ]; then
        echo "error: DOCKER_COMPOSE_VERSION not defined"
        echo "example usage:"
        # Same as
        # DOCKER_COMPOSE_VERSION=1.26.2; ./git_clone_and_buildx.sh
        echo "    export DOCKER_COMPOSE_VERSION=1.26.2"
        echo "    ./git_clone_and_buildx_arm.sh"
        exit 1
fi
export HCL_BAKE_FILE=bake_tagged_arm_${DOCKER_COMPOSE_VERSION}.hcl
set -ex
read -p "Clone docker/compose branch ${DOCKER_COMPOSE_VERSION} [Y/N]? " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Nn]$ ]]
then
    git clone --single-branch --branch ${DOCKER_COMPOSE_VERSION} https://github.com/docker/compose.git
fi
# ---
# Embed docker-compose "run.sh" in the image
# Copy the run.sh script to root git folder:
cp ./compose/script/run/run.sh ./compose/run.sh
# Replace the docker image name to be used in the script
# from docker/compose:$VERSION to ptrn2l2/docker-compose-arm:$VERSION
sed -i 's/docker\/compose/ptrn2l2\/docker-compose-arm/g' ./compose/run.sh
# Copy Dockerfile in the new ptrn2l2_dc.Dockerfile 
cp -f ./compose/Dockerfile ./compose/ptrn2l2_dc.Dockerfile
# add the "run.sh" script to the new runsh_in.Dockerfile
echo "RUN mkdir -p /@compose_script" >> ./compose/ptrn2l2_dc.Dockerfile
echo "COPY run.sh /@compose_script/docker-compose" >> ./compose/ptrn2l2_dc.Dockerfile
echo "COPY run.sh /@compose_script/docker-compose-${DOCKER_COMPOSE_VERSION}.sh" >>  ./compose/ptrn2l2_dc.Dockerfile
echo "COPY run.sh /@compose_script/." >>  ./compose/ptrn2l2_dc.Dockerfile
# ---
cp ./${HCL_BAKE_FILE} ./compose/${HCL_BAKE_FILE}
cd ./compose/
docker buildx bake -f ./${HCL_BAKE_FILE} --print
read -p "If the bake file is OK press Y to continue [Y/N]? " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo Exiting!
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
fi
docker buildx bake -f ./${HCL_BAKE_FILE}
cd ..
# Post build (optional)
# clean git downloaded files, removing the new added build files
rm ./compose/${HCL_BAKE_FILE}
rm ./compose/ptrn2l2_dc.Dockerfile
rm ./compose/run.sh
# After build: make docker-compose script from run.sh
# Replacing the docker image name to be used in the script
# from docker/compose:$VERSION to ptrn2l2/docker-compose-arm:$VERSION
cp ./compose/script/run/run.sh ./docker-compose-${DOCKER_COMPOSE_VERSION}.sh
sed -i 's/docker\/compose/ptrn2l2\/docker-compose-arm/g' docker-compose-${DOCKER_COMPOSE_VERSION}.sh
ln -s docker-compose-${DOCKER_COMPOSE_VERSION}.sh docker-compose
echo "Copy ./docker-compose-${DOCKER_COMPOSE_VERSION}.sh and  docker-compose in your bin folder (~/bin)"
echo "preserving symbolik links, ex:" 
echo "     cp -P ./docker-compose* ~/bin/."
echo ""
