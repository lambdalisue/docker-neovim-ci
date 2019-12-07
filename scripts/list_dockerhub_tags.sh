#!/bin/sh
ROOT=$(cd $(dirname $0); pwd)
URL="https://registry.hub.docker.com/v2/repositories/lambdalisue/neovim-ci/tags/"
curl -SL $URL | jq -r '.results[].name' | sort | comm -23 - $ROOT/ignore_tags.txt
