<# 
.SYNOPSIS
    Build and install VPet AI Plugin
#>

param(
    [string]$VPetPath = "C:\Program Files (x86)\Steam\steamapps\common\VPet",
    [string]$Configuration = "Release"
)

$ErrorActionPreference = "Stop"

Write-Host "VPet AI Plugin Build & Install" -ForegroundColor Cyan
Write-Host "VPet Path: $VPetPath" -ForegroundColor Gray

# Verify VPet installation
$coreDll = Join-Path $VPetPath "VPet-Simulator.Core.dll"
$interfaceDll = Join-Path $VPetPath "VPet-Simulator.Windows.Interface.dll"

if (-not (Test-Path $coreDll)) {
    Write-Error "VPet-Simulator.Core.dll not found at $VPetPath"
    Write-Host "Please install VPet-Simulator from Steam or update \$VPetPath parameter" -ForegroundColor Yellow
    exit 1
}

if (-not (Test-Path $interfaceDll)) {
    Write-Error "VPet-Simulator.Windows.Interface.dll not found at $VPetPath"
    exit 1
}

Write-Host "VPet installation verified" -ForegroundColor Green

# Build
Write-Host "`nBuilding plugin..." -ForegroundColor Cyan
$projectPath = "C:\Users\Administrator\Documents\Default Project\VPet.AIPlugin\VPet.AIPlugin.csproj"
dotnet build $projectPath -c $Configuration -p:VPetPath="$VPetPath"

if ($LASTEXITCODE -ne 0) {
    Write-Error "Build failed"
    exit 1
}

Write-Host "Build successful!" -ForegroundColor Green

# Install
$modFolder = Join-Path $VPetPath "mod\AIPlugin"
Write-Host "`nInstalling to $modFolder..." -ForegroundColor Cyan

if (-not (Test-Path $modFolder)) {
    New-Item -ItemType Directory -Path $modFolder | Out-Null
}

$outputDir = "C:\Users\Administrator\Documents\Default Project\VPet.AIPlugin\bin\$Configuration\net8.0-windows"
Copy-Item "$outputDir\VPet.AIPlugin.dll" $modFolder -Force
# Newtonsoft.Json.dll is already in VPet folder, no need to copy

Write-Host "Installation complete!" -ForegroundColor Green
Write-Host "`nNext steps:" -ForegroundColor Cyan
Write-Host "1. Restart VPet-Simulator"
Write-Host "2. Right-click pet -> MOD Config -> AI Assistant"
Write-Host "3. Configure your API endpoint, key, and model"
Write-Host "4. Enable 'Automatic Actions' for autonomous behavior"