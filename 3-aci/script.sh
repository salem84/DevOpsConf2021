#!/bin/bash
set -x #echo on

# Image variables
REGISTRY_NAME=devopsconf
REGISTRY_URL=$REGISTRY_NAME.azurecr.io
REGISTRY_USERNAME=devopsconf
REGISTRY_PASSWORD=Ygse8iOikcPht4uJTir+qG3slF611Q+s
IMAGE_NAME=ubuntu-agent
IMAGE_VERSION=1.0

# ACI variables
RESOURCE_GROUP=RG_DevOpsConf
ACI_NAME=aci-ubuntu-agent

# Azure DevOps variables
AZP_URL=https://dev.azure.com/giorgiolasala
AZP_TOKEN=
AZP_POOL=aci

# Login to registry
az acr login -n $REGISTRY_NAME

# Build 
# docker build -t $IMAGE_NAME:$IMAGE_VERSION .
# az acr build --registry $REGISTRY_NAME --image $IMAGE_NAME .

# Tag & Push
# docker tag $IMAGE_NAME:$IMAGE_VERSION $REPOSITORY_URL/$IMAGE_NAME:$IMAGE_VERSION
# ocker push $REPOSITORY_URL/$IMAGE_NAME:$IMAGE_VERSION

az container create \
    -g $RESOURCE_GROUP \
    -n $ACI_NAME --image $REGISTRY_URL/$IMAGE_NAME:$IMAGE_VERSION \
    --registry-username $REGISTRY_USERNAME --registry-password $REGISTRY_PASSWORD \
    --cpu 2 --memory 4 \
    --environment-variables AZP_URL=$AZP_URL AZP_TOKEN=$AZP_TOKEN AZP_POOL=$AZP_POOL