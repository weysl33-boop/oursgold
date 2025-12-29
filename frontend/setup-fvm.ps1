# PowerShell Script to Setup FVM and Flutter for Precious Metals Social Platform
# Run this script from the frontend directory

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "FVM & Flutter Setup Script" -ForegroundColor Cyan
Write-Host "Precious Metals Social Platform" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# Check if FVM is installed
Write-Host "Checking for FVM installation..." -ForegroundColor Yellow
$fvmExists = Get-Command fvm -ErrorAction SilentlyContinue

if (-not $fvmExists) {
    Write-Host "FVM is not installed!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please install FVM first using one of these methods:" -ForegroundColor Yellow
    Write-Host "1. Via Chocolatey: choco install fvm" -ForegroundColor White
    Write-Host "2. Via Dart: dart pub global activate fvm" -ForegroundColor White
    Write-Host "3. Download from: https://fvm.app/docs/getting_started/installation" -ForegroundColor White
    Write-Host ""
    Write-Host "After installation, run this script again." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "See FVM-SETUP-GUIDE.md for detailed instructions." -ForegroundColor Cyan
    exit 1
}

Write-Host "✓ FVM is installed!" -ForegroundColor Green
Write-Host ""

# Show FVM version
$fvmVersion = fvm --version
Write-Host "FVM Version: $fvmVersion" -ForegroundColor Cyan
Write-Host ""

# Install Flutter stable
Write-Host "Installing Flutter stable version..." -ForegroundColor Yellow
Write-Host "This may take a few minutes..." -ForegroundColor Gray
fvm install stable

if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ Failed to install Flutter!" -ForegroundColor Red
    exit 1
}

Write-Host "✓ Flutter installed successfully!" -ForegroundColor Green
Write-Host ""

# Use Flutter stable for this project
Write-Host "Configuring project to use Flutter stable..." -ForegroundColor Yellow
fvm use stable --force

if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ Failed to configure Flutter version!" -ForegroundColor Red
    exit 1
}

Write-Host "✓ Project configured!" -ForegroundColor Green
Write-Host ""

# Verify Flutter installation
Write-Host "Verifying Flutter installation..." -ForegroundColor Yellow
fvm flutter --version

Write-Host ""
Write-Host "✓ Flutter Doctor check..." -ForegroundColor Yellow
fvm flutter doctor

Write-Host ""
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "Setup Complete!" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "1. Run: fvm flutter create . --org com.preciousmetals --project-name precious_metals_app" -ForegroundColor White
Write-Host "2. Configure your IDE (see FVM-SETUP-GUIDE.md)" -ForegroundColor White
Write-Host "3. Start development!" -ForegroundColor White
Write-Host ""
Write-Host "Useful Commands:" -ForegroundColor Yellow
Write-Host "  fvm flutter pub get       - Install dependencies" -ForegroundColor White
Write-Host "  fvm flutter run          - Run the app" -ForegroundColor White
Write-Host "  fvm flutter test         - Run tests" -ForegroundColor White
Write-Host "  fvm flutter doctor       - Check setup" -ForegroundColor White
Write-Host ""
