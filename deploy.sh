#!/bin/bash
# https://www.thecodebuzz.com/azure-cli-push-a-docker-container-to-azure-private-registry/

az login

az acr login --name innovarregistry

docker build -t bevmarket:v1.0.0 . # v1.0.0 is the version version to use

docker tag bevmarket:v1.0.0 innovarregistry-d0aab0dedqaqc5df.azurecr.io/bevmarket:v1.0.0

docker push innovarregistry-d0aab0dedqaqc5df.azurecr.io/bevmarket:v1.0.0
