#!/bin/bash

# make sure we're in the correct directory
cd "$(dirname "$0")"/../
export WORKSPACE="$PWD"

# setup haxelib
mkdir -p haxelib || exit 1
export HAXELIB_PATH="$PWD"/haxelib
export CI=1
export CI_RUNNING=1

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
