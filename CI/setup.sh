#!/bin/bash

# make sure we're in the correct directory
cd "$(dirname "$0")"/../
export WORKSPACE="$PWD"

# setup haxelib
mkdir -p haxelib || exit 1
export HAXELIB_PATH="$PWD"/haxelib
export CI=1
export CI_RUNNING=1

# install all needed libraries
haxelib install hxcpp || exit $?
haxelib install hxcs || exit $?
haxelib install buddy || exit $?

# build the build scripts
cd Haxe/BuildTool
haxe build.hxml || exit 1
