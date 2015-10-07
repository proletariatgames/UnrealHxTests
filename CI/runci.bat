REM run setup and setup some env vars
set WORKSPACE=%CD%
SET HAXELIB_PATH=%WORKSPACE%/haxelib
SET CI=1
SET CI_RUNNING=1

REM setup haxelib

if not exist haxelib mkdir haxelib

REM install all needed libraries
haxelib install hxcpp
haxelib install hxcs
haxelib install buddy

REM build the build scripts
cd Plugins/UE4Haxe/Haxe/BuildTool
haxe build.hxml

cd %WORKSPACE%

REM build
cd "%UE4%"

REM build the unit tests
echo "building unit tests"
echo "Engine\Binaries\DotNET\UnrealBuildTool.exe HaxeUnitTests Win64 Development \"-project=%WORKSPACE%/HaxeUnitTests.uproject\" -editorrecompile -noubtmakefiles"
Engine\Binaries\DotNET\UnrealBuildTool.exe HaxeUnitTests Win64 Development "-project=%WORKSPACE%/HaxeUnitTests.uproject" -editorrecompile -noubtmakefiles -rocket

echo "running unit tests"
set MAP=/Game/Maps/HaxeTestEntryPoint
echo "%UE4%/Engine/Binaries/Win64/UE4Editor.exe %WORKSPACE%/HaxeUnitTests.uproject -server %MAP% -log -stdout
"%UE4%/Engine/Binaries/Win64/UE4Editor.exe" "%WORKSPACE%/HaxeUnitTests.uproject" -server "%MAP%" -log -stdout
