#!/bin/bash

# run setup and setup some env vars
source "$(dirname "$0")"/setup.sh

if [ -z "$UE4" ]; then
  echo "The environment variable 'UE4' is not defined. It should point to your chosen UnrealEditor root path"
  exit 1
fi

if [ "$(uname)" == "Darwin" ]; then
  BUILD_ARGS="Engine/Build/BatchFiles/Mac/Build.sh HaxeUnitTests Mac"
  BINPATH=Engine/Binaries/Mac/UE4Editor.app/Contents/MacOS/UE4Editor
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
  BUILD_ARGS="Engine/Build/BatchFiles/Linux/Build.sh HaxeUnitTests Linux"
  BINPATH=Engine/Binaries/Linux/UE4Editor
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
  BUILD_ARGS="Engine/Build/BatchFiles/Build.bat HaxeUnitTests Win64"
  BINPATH=Engine/Binaries/Win64/UE4Editor.exe
else
  echo "Platform not supported! ($(uname))"
  exit 1
fi

# build it
cd "$UE4"
./$BUILD_ARGS Development "-project=$WORKSPACE/HaxeUnitTests.uproject" || exit $?

MAP=/Game/Maps/HaxeTestEntryPoint
"$UE4"/$BINPATH "$PWD"/HaxeUnitTests.uproject -server "$MAP" -log || exit $?
