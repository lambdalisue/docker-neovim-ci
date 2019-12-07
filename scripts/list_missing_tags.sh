#!/bin/sh
ROOT=$(cd $(dirname $0); pwd)
A=$(mktemp)
B=$(mktemp)
$ROOT/list_github_tags.sh > $A
$ROOT/list_dockerhub_tags.sh > $B
comm -23 $A $B
