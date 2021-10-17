#!/bin/bash
set -x #echo on

az container create \
    -g "RG_DevOpsConf" \
    -n "test2" --image "devopsconf.azurecr.io/ubuntu-agent:1.0" \
    --registry-username "devopsconf" \
    --registry-password "$(az acr credential show -n devopsconf --query "passwords[0].value" -o tsv)"