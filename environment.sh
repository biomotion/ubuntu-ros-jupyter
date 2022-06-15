#!/bin/bash

export REPO_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

export PATH=$PATH:$REPO_PATH/scripts

export U18ENV_IMAGE_NAME=ubuntu18-env:latest
export U18ENV_CONTAINER_NAME=ubuntu18-env
