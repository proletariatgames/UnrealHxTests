REM run setup and setup some env vars
set WORKSPACE=%CD%
SET HAXELIB_PATH="%WORKSPACE%"/haxelib
SET CI=1
SET CI_RUNNING=1

CI/setup.bat
cd %WORKSPACE%

IF [%UE4%] == [] GOTO UE4NotDefined

REM build
cd "$UE4"

REM build the unit tests
echo "building unit tests"
echo "Engine/Build/BatchFiles/Build.bat HaxeUnitTests Win64 Development \"-project=%WORKSPACE%/HaxeUnitTests.uproject\" -editorrecompile -noubtmakefiles"
Engine/Build/BatchFiles/Build.bat HaxeUnitTests Win64 Development "-project=%WORKSPACE%/HaxeUnitTests.uproject" -editorrecompile -noubtmakefiles -rocket || exit 2

echo "running unit tests"
set MAP=/Game/Maps/HaxeTestEntryPoint
echo "%UE4%/%BINPATH% %WORKSPACE%/HaxeUnitTests.uproject -server %MAP% -log -stdout
"$UE4"/$BINPATH "$WORKSPACE"/HaxeUnitTests.uproject -server "$MAP" -log -stdout || exit 3

exit 0

:UE4NotDefined
echo "The environment variable 'UE4' is not defined. It should point to your chosen UnrealEditor root path"
exit 1
