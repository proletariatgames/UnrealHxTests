set WORKSPACE=%CD%
SET CI=1
SET CI_RUNNING=1

cd /D "%UE4%"

set MAP=/Game/Maps/HaxeTestEntryPoint
echo "%UE4%/Engine/Binaries/Win64/UE4Editor.exe %WORKSPACE%/HaxeUnitTests.uproject -server %MAP% -stdout
"%VS140COMNTOOLS%\..\IDE\devenv.exe" /DebugExe "%UE4%/Engine/Binaries/Win64/UE4Editor.exe" "%WORKSPACE%/HaxeUnitTests.uproject" -run=HaxeUnitTests.UpdateAsset "2017-05-10_0223 AM" || exit /b
