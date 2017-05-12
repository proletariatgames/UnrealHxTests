REM run setup and setup some env vars
set WORKSPACE=%CD%
SET HAXELIB_PATH=%WORKSPACE%/haxelib
SET CI=1
SET CI_RUNNING=1

REM setup haxelib

if not exist haxelib mkdir haxelib

REM install all needed libraries
haxelib install hxcpp || exit /b
haxelib install hxcs || exit /b
haxelib install buddy || exit /b
haxelib install promhx || exit /b

REM build the build scripts
cd Plugins/UE4Haxe
haxe init-plugin.hxml || exit /b

cd %WORKSPACE%

REM build
cd /D "%UE4%"

REM build the unit tests
echo "building unit tests"
echo "Engine\Binaries\DotNET\UnrealBuildTool.exe HaxeUnitTests Win64 Development \"-project=%WORKSPACE%/HaxeUnitTests.uproject\" -editorrecompile -noubtmakefiles -AllowStdOutLogVerbosity"
Engine\Binaries\DotNET\UnrealBuildTool.exe HaxeUnitTests Win64 Development "-project=%WORKSPACE%/HaxeUnitTests.uproject" -editorrecompile -noubtmakefiles -rocket -AllowStdOutLogVerbosity || exit /b

REM build the commandlet to create/update asset
echo "running the update asset commandlet"
For /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set mydate=%%c-%%a-%%b)
For /f "tokens=1-2 delims=/:" %%a in ('time /t') do (set mytime=%%a%%b)
SET CUSTOM_STAMP=%mydate%_%mytime%
"%UE4%/Engine/Binaries/Win64/UE4Editor.exe" "%WORKSPACE%/HaxeUnitTests.uproject" -run=HaxeUnitTests.UpdateAsset "%CUSTOM_STAMP%" || exit /b

echo "running unit tests"
set MAP=/Game/Maps/HaxeTestEntryPoint
echo "%UE4%/Engine/Binaries/Win64/UE4Editor.exe %WORKSPACE%/HaxeUnitTests.uproject -server %MAP% -stdout -AllowStdOutLogVerbosity
"%UE4%/Engine/Binaries/Win64/UE4Editor.exe" "%WORKSPACE%/HaxeUnitTests.uproject" -server "%MAP%" -stdout -AllowStdOutLogVerbosity

echo "pass 2"
haxe --cwd "%WORKSPACE%\Haxe" gen-build-script.hxml -D pass=2 || exit /b
echo "%UE4%/Engine/Binaries/Win64/UE4Editor.exe %WORKSPACE%/HaxeUnitTests.uproject -server %MAP% -stdout -AllowStdOutLogVerbosity
"%UE4%/Engine/Binaries/Win64/UE4Editor.exe" "%WORKSPACE%/HaxeUnitTests.uproject" -server "%MAP%" -stdout -AllowStdOutLogVerbosity || exit /b
