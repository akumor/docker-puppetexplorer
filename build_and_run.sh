#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "${SCRIPT_DIR}"

HOST_DIR="/tmp/"

# Remove unused docker images
for x in $(docker images -q); do docker rmi $x; done
# Build the docker image
docker build --rm=true --tag=akumor/puppetexplorer .
[ "$?" != "0" ] && echo 'ERROR: Failed to build image.' && exit 1
# Kill and remove existing docker image of the same name
[ "$(docker ps -a | grep -c "puppetexplorer-container")" -gt 0 ] && docker rm --force=true "puppetexplorer-container"
# Run the image in docker
docker run --cpuset-cpus="0,1" \
           --memory="4g" \
           --name="puppetexplorer-container" \
           --tty=false \
           akumor/puppetexplorer
                       
