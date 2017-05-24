#!/bin/bash
set -x

# run setup and setup some env vars
export CI=1
export CI_RUNNING=1
export WORKSPACE="$PWD"

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
  EXTRAARGS=-rocket

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
  EXTRAARGS=-rocket
else
  echo "Platform not supported! ($(uname))"
  exit 1
fi
if [ -z "$TIMECMD" ]; then
  TIMECMD=
fi

# build
cd "$UE4"

echo "pass 2"
haxe --cwd "$WORKSPACE/Haxe" gen-build-script.hxml -D pass=2 || exit $?
MAP=/Game/Maps/HaxeTestEntryPoint
$TIMECMD "$UE4"/$BINPATH "$WORKSPACE"/HaxeUnitTests.uproject -server "$MAP" -log -stdout || exit $?
