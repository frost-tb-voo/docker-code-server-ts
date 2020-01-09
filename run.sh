#!/bin/sh

IMAGE=novsyama/code-server-ts
CODER_HOME=/home/coder

S_DIR=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)
PROJECT_DIR=${S_DIR}/..
PROJECT_DIR=`readlink -f ${PROJECT_DIR}`

echo open :8080
sudo -E docker pull ${IMAGE}
sudo -E docker stop vscode
sudo -E docker rm vscode
sudo -E docker run --name=vscode --net=host -d \
 --restart=always \
 -v "${PROJECT_DIR}:${CODER_HOME}/project" \
 -w ${CODER_HOME}/project \
 ${IMAGE} \
 code-server \
 --auth none

