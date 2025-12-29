# PowerShell Script to Initialize Flutter Project
# Precious Metals Social Platform - Frontend

$ErrorActionPreference = "Stop"

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "Flutter Project Initialization" -ForegroundColor Cyan
Write-Host "Precious Metals Social Platform" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# Configuration
$ORG_NAME = "com.preciousmetals"
$PROJECT_NAME = "precious_metals_app"
$PLATFORMS = "android,ios"

# Check if Flutter is available
Write-Host "Checking Flutter installation..." -ForegroundColor Yellow

$flutterCommand = "flutter"
$useFvm = $false

# Try FVM first
if (Get-Command fvm -ErrorAction SilentlyContinue) {
    Write-Host "Found FVM, checking if Flutter is configured..." -ForegroundColor Cyan
    $fvmFlutter = fvm flutter --version 2>&1
    if ($LASTEXITCODE -eq 0) {
        $flutterCommand = "fvm flutter"
        $useFvm = $true
        Write-Host "✓ Using FVM Flutter" -ForegroundColor Green
    } else {
        Write-Host "FVM found but Flutter not configured. Run setup-fvm.ps1 first or using global Flutter." -ForegroundColor Yellow
    }
}

# Check global Flutter
if (-not $useFvm) {
    if (Get-Command flutter -ErrorAction SilentlyContinue) {
        Write-Host "✓ Using global Flutter installation" -ForegroundColor Green
    } else {
        Write-Host "✗ Flutter not found!" -ForegroundColor Red
        Write-Host ""
        Write-Host "Please install Flutter or run setup-fvm.ps1" -ForegroundColor Yellow
        exit 1
    }
}

Write-Host ""

# Show Flutter version
Write-Host "Flutter Version:" -ForegroundColor Cyan
Invoke-Expression "$flutterCommand --version"
Write-Host ""

# Check if project already initialized
if (Test-Path "pubspec.yaml") {
    Write-Host "⚠ Flutter project already initialized (pubspec.yaml exists)" -ForegroundColor Yellow
    $response = Read-Host "Do you want to re-initialize? This will overwrite files. (y/N)"
    if ($response -ne "y" -and $response -ne "Y") {
        Write-Host "Initialization cancelled." -ForegroundColor Yellow
        exit 0
    }
    $overwrite = "--overwrite"
} else {
    $overwrite = ""
}

Write-Host ""
Write-Host "Initializing Flutter project..." -ForegroundColor Yellow
Write-Host "Organization: $ORG_NAME" -ForegroundColor Gray
Write-Host "Project Name: $PROJECT_NAME" -ForegroundColor Gray
Write-Host "Platforms: $PLATFORMS" -ForegroundColor Gray
Write-Host ""

# Create Flutter project
$createCommand = "$flutterCommand create . --org $ORG_NAME --project-name $PROJECT_NAME --platforms $PLATFORMS $overwrite"
Write-Host "Running: $createCommand" -ForegroundColor Gray
Invoke-Expression $createCommand

if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ Failed to create Flutter project!" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "✓ Flutter project created successfully!" -ForegroundColor Green
Write-Host ""

# Get dependencies
Write-Host "Installing dependencies..." -ForegroundColor Yellow
Invoke-Expression "$flutterCommand pub get"

if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ Failed to install dependencies!" -ForegroundColor Red
    exit 1
}

Write-Host "✓ Dependencies installed!" -ForegroundColor Green
Write-Host ""

# Run Flutter doctor
Write-Host "Running Flutter doctor to check setup..." -ForegroundColor Yellow
Invoke-Expression "$flutterCommand doctor"

Write-Host ""
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "Initialization Complete!" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Project Structure Created:" -ForegroundColor Yellow
Write-Host "  ✓ lib/          - Dart source code" -ForegroundColor White
Write-Host "  ✓ test/         - Unit and widget tests" -ForegroundColor White
Write-Host "  ✓ android/      - Android platform code" -ForegroundColor White
Write-Host "  ✓ ios/          - iOS platform code" -ForegroundColor White
Write-Host "  ✓ pubspec.yaml  - Project dependencies" -ForegroundColor White
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "1. Review the project structure" -ForegroundColor White
Write-Host "2. Configure your IDE (see README.md)" -ForegroundColor White
Write-Host "3. Start implementing features (see tasks.md)" -ForegroundColor White
Write-Host ""
Write-Host "Useful Commands:" -ForegroundColor Yellow
if ($useFvm) {
    Write-Host "  fvm flutter run          - Run the app" -ForegroundColor White
    Write-Host "  fvm flutter test         - Run tests" -ForegroundColor White
    Write-Host "  fvm flutter pub add pkg  - Add a dependency" -ForegroundColor White
} else {
    Write-Host "  flutter run              - Run the app" -ForegroundColor White
    Write-Host "  flutter test             - Run tests" -ForegroundColor White
    Write-Host "  flutter pub add pkg      - Add a dependency" -ForegroundColor White
}
Write-Host ""
Write-Host "Documentation:" -ForegroundColor Yellow
Write-Host "  README.md                - Setup and usage guide" -ForegroundColor White
Write-Host "  FVM-SETUP-GUIDE.md       - FVM installation guide" -ForegroundColor White
Write-Host "  openspec/changes/.../    - Project specifications" -ForegroundColor White
Write-Host ""
