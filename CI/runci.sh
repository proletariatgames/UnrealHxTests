#!/bin/bash

# run setup and setup some env vars
source "$(dirname "$0")"/setup.sh

if [ -z "$UE4" ]; then
  echo "The environment variable 'UE4' is not defined. It should point to your chosen UnrealEditor root path"
  exit 1
fi

if [ "$(uname)" == "Darwin" ]; then
  # it doesn't work with more than one extra parameter
  #BUILD_PATH="Engine/Build/BatchFiles/Mac/Build.sh"
  BUILD_PATH="mono Engine/Binaries/DotNET/UnrealBuildTool.exe"
  PLATFORM=Mac
  BINPATH=Engine/Binaries/Mac/UE4Editor.app/Contents/MacOS/UE4Editor

  cd "$UE4"
  source Engine/Build/BatchFiles/Mac/SetupMono.sh Engine/Build/BatchFiles/Mac
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
  BUILD_PATH="Engine/Build/BatchFiles/Linux/Build.sh"
  PLATFORM=Linux
  BINPATH=Engine/Binaries/Linux/UE4Editor
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
  BUILD_PATH="Engine/Build/BatchFiles/Build.bat"
  PLATFORM=Win64
  BINPATH=Engine/Binaries/Win64/UE4Editor.exe
else
  echo "Platform not supported! ($(uname))"
  exit 1
fi

# build
cd "$UE4"

# build the unit tests
echo "building unit tests"
./$BUILD_PATH HaxeUnitTests $PLATFORM Development "-project=$WORKSPACE/HaxeUnitTests.uproject" -editorrecompile -progress -noubtmakefiles || exit $?

echo "running unit tests"
MAP=/Game/Maps/HaxeTestEntryPoint
"$UE4"/$BINPATH "$PWD"/HaxeUnitTests.uproject -server "$MAP" -log -stdout || exit $?
