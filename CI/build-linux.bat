REM run setup and setup some env vars
set WORKSPACE=%CD%
REM SET HAXELIB_PATH=%WORKSPACE%/haxelib
SET CI=1
SET CI_RUNNING=1

REM setup haxelib

if not exist haxelib mkdir haxelib

REM install all needed libraries
REM haxelib install hxcpp || exit /b 1
REM haxelib install hxcs || exit /b 1
REM haxelib install buddy || exit /b 1
REM haxelib install promhx || exit /b 1

REM build the build scripts
cd Plugins/UE4Haxe
rem haxe init-plugin.hxml -D UE_VER=%UE_VER%|| exit /b 1

cd %WORKSPACE%

REM build
cd /D "%UE4%"

REM build the unit tests
echo "building unit tests"
echo "Engine\Binaries\DotNET\UnrealBuildTool.exe HaxeUnitTests Linux Development \"-project=%WORKSPACE%/HaxeUnitTests.uproject\" -AllowStdOutLogVerbosity"
Engine\Binaries\DotNET\UnrealBuildTool.exe HaxeUnitTests Linux Development "-project=%WORKSPACE%/HaxeUnitTests.uproject" -AllowStdOutLogVerbosity|| exit /b 1
