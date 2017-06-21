REM run setup and setup some env vars
set WORKSPACE=%CD%
SET HAXELIB_PATH=%WORKSPACE%/haxelib
SET CI=1
SET CI_RUNNING=1

cd Plugins\UE4Haxe

haxe init-plugin.hxml -D UE_VER=%UE_VER%|| exit /b 1

cd %WORKSPACE%

REM build
cd /D "%UE4%"

REM build the unit tests
echo "building unit tests"
echo "Engine\Binaries\DotNET\UnrealBuildTool.exe HaxeProgram Win64 Development \"-project=%WORKSPACE%/HaxeUnitTests.uproject\" -editorrecompile -noubtmakefiles -AllowStdOutLogVerbosity"
Engine\Binaries\DotNET\UnrealBuildTool.exe HaxeProgram Win64 Shipping "-project=%WORKSPACE%/HaxeUnitTests.uproject" || exit /b 1
