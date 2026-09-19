@echo off
echo Building VPet AI Plugin...

REM Set your VPet installation path here
REM Default Steam location:
set VPetPath=C:\Program Files (x86)\Steam\steamapps\common\VPet-Simulator

REM Check if path exists
if not exist "%VPetPath%\VPet-Simulator.Core.dll" (
    echo.
    echo ERROR: VPet-Simulator.Core.dll not found at %VPetPath%
    echo Please edit this file and set the correct VPetPath
    echo.
    pause
    exit /b 1
)

echo Found VPet at: %VPetPath%
echo.

dotnet build VPet.AIPlugin.csproj -c Release -p:VPetPath="%VPetPath%"

if %errorlevel% neq 0 (
    echo.
    echo Build failed!
    pause
    exit /b 1
)

echo.
echo Build successful!
echo Output: bin\Release\net8.0-windows\
echo.
echo To install, copy these files to your VPet mod folder:
echo   %VPetPath%\mod\AIPlugin\
echo     - VPet.AIPlugin.dll
echo     - Newtonsoft.Json.dll (if not already in VPet folder)
echo.
pause