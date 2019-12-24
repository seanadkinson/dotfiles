#!/usr/bin/env bash
set -e

# https://stackoverflow.com/a/24112741
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
pushd "$parent_path/proto/platform"

PBANDK_HOME="$HOME/code/pb-and-k"
pushd "$PBANDK_HOME"
./gradlew :protoc-gen-kotlin:protoc-gen-kotlin-jvm:installDist
popd

OUT="../../kotlin/build/generated/source/proto/main/kotlin"
rm -Rf "${OUT}"
mkdir -p "${OUT}"

PLUGIN_PATH="$HOME/code/pb-and-k/protoc-gen-kotlin/protoc-gen-kotlin-jvm/build/install/protoc-gen-kotlin/bin"

PATH="$PLUGIN_PATH:$PATH"
  protoc \
  --kotlin_out="${OUT}" \
  --kotlin_opt="log=debug" \
  --kotlin_opt="kotlin_package_mapping=google.api->pbandk.google.api" \
  --kotlin_opt="json_support=true" \
  --kotlin_opt="json_use_proto_names=true" \
  $(find . -iname "*.proto")

popd
