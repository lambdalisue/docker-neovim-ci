#!/bin/sh
ROOT=$(cd $(dirname $0); pwd)
URL="https://api.github.com/repos/neovim/neovim/tags"
curl -SL $URL | jq -r '.[].name' | sort | comm -23 - $ROOT/ignore_tags.txt
