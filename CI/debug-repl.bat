set WORKSPACE=%CD%
SET CI=1
SET CI_RUNNING=1

cd /D "%UE4%"

set MAP=/Game/Maps/HaxeTestEntryPoint
echo "%UE4%/Engine/Binaries/Win64/UE4Editor.exe %WORKSPACE%/HaxeUnitTests.uproject -ExecCmds="Automation RunTests ClientServerAutomation; RunTests ClientServerAutomation; Quit" -stdout -AllowStdOutLogVerbosity
"%VS140COMNTOOLS%\..\IDE\devenv.exe" /DebugExe "%UE4%/Engine/Binaries/Win64/UE4Editor.exe" "%WORKSPACE%/HaxeUnitTests.uproject" -ExecCmds="Automation RunTests ClientServerAutomation; RunTests ClientServerAutomation" -stdout -AllowStdOutLogVerbosity || exit /b 1
