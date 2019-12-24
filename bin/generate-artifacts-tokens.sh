#!/usr/bin/env bash
set -e

generate-token.sh $1 $2 $3 artifacts service streem:service:artifacts
generate-token.sh $1 $2 $3 prospector artifacts streem:service:prospector
generate-token.sh $1 $2 $3 service artifacts streem:service:service

