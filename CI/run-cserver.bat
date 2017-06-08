REM run setup and setup some env vars
set WORKSPACE=%CD%
SET HAXELIB_PATH=%WORKSPACE%/haxelib
SET CI=1
SET CI_RUNNING=1

echo "hot reload tests"
haxe --cwd "%WORKSPACE%\Haxe" gen-build-script.hxml -D pass=3 || exit /b 1
echo "%UE4%/Engine/Binaries/Win64/UE4Editor.exe %WORKSPACE%/HaxeUnitTests.uproject -ExecCmds="Automation RunTests ClientServer; Quit" -stdout -AllowStdOutLogVerbosity
"%UE4%/Engine/Binaries/Win64/UE4Editor.exe" "%WORKSPACE%/HaxeUnitTests.uproject" -ExecCmds="Automation RunTests ClientServer; Quit" -stdout -AllowStdOutLogVerbosity || exit /b 1
