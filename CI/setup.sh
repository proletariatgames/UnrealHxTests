#!/bin/bash

export WORKSPACE="$(dirname $(readlink -f "$0"))"/../

# make sure we're in the correct directory
cd $WORKSPACE
echo $PWD

mkdir -p haxelib
export HAXELIB_PATH="$PWD"/haxelib
export CI=1

haxelib install hxcpp || exit $?
# install all needed libraries
if [ -f Haxe/arguments.hxml ]; then
  haxelib install Haxe/arguments.hxml || exit $?
else
  echo "arguments.hxml doesn't exist!"
fi
