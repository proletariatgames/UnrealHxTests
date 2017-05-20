#!/bin/sh
export WORKSPACE=$PWD
export SET CI=1
export SET CI_RUNNING=1
BINPATH=Engine/Binaries/Linux/UE4Editor

MAP=/Game/Maps/HaxeTestEntryPoint
gdb --args "$UE4"/$BINPATH "$WORKSPACE"/HaxeUnitTests.uproject -server "$MAP" -log -stdout || exit $?
