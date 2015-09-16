#!/bin/bash

export WORKSPACE="$(dirname $(readlink -f "$0"))"/../

# make sure we're in the correct directory
cd "$WORKSPACE"

# setup haxelib
mkdir -p haxelib
export HAXELIB_PATH="$PWD"/haxelib
export CI=1

haxelib install hxcpp || exit $?
haxelib install hxcs || exit $?
# install all needed libraries
if [ -f Haxe/arguments.hxml ]; then
  haxelib install Haxe/arguments.hxml || exit $?
else
  echo "arguments.hxml doesn't exist!"
fi

# make sure we're on the very latest ue4hx version
cd "$WORKSPACE"/Plugins/UE4Haxe
git fetch || exit 1
git checkout -f origin/master || exit 1

# build the build scripts
cd Haxe/BuildTool
haxe build.hxml || exit 1
