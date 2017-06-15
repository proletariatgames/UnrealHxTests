set WORKSPACE=%CD%
SET CI=1
SET CI_RUNNING=1

cd /D "%UE4%"

"%VS140COMNTOOLS%\..\IDE\devenv.exe" /DebugExe "%UE4%/Engine/Binaries/Win64/UE4Editor.exe" "%WORKSPACE%/HaxeUnitTests.uproject" -stdout -AllowStdOutLogVerbosity || exit /b 1
