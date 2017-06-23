REM run setup and setup some env vars
set WORKSPACE=%CD%
SET CI=1
SET CI_RUNNING=1

REM setup haxelib

set MAP=/Game/Maps/HaxeTestEntryPoint
echo "%UE4%/Engine/Binaries/Win64/UE4Editor.exe %WORKSPACE%/HaxeUnitTests.uproject -server %MAP% -stdout -AllowStdOutLogVerbosity
"%UE4%/Engine/Binaries/Win64/UE4Editor.exe" "%WORKSPACE%/HaxeUnitTests.uproject" -server "%MAP%" -stdout -AllowStdOutLogVerbosity
