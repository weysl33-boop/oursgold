#!/bin/bash
# Bash Script to Setup FVM and Flutter for Precious Metals Social Platform
# Run this script from the frontend directory

set -e  # Exit on error

echo "====================================="
echo "FVM & Flutter Setup Script"
echo "Precious Metals Social Platform"
echo "====================================="
echo ""

# Check if FVM is installed
echo "Checking for FVM installation..."
if ! command -v fvm &> /dev/null; then
    echo "✗ FVM is not installed!"
    echo ""
    echo "Please install FVM first using one of these methods:"
    echo "1. Via Chocolatey (Windows): choco install fvm"
    echo "2. Via Dart: dart pub global activate fvm"
    echo "3. Via Homebrew (macOS): brew tap leoafarias/fvm && brew install fvm"
    echo "4. Download from: https://fvm.app/docs/getting_started/installation"
    echo ""
    echo "After installation, run this script again."
    echo ""
    echo "See FVM-SETUP-GUIDE.md for detailed instructions."
    exit 1
fi

echo "✓ FVM is installed!"
echo ""

# Show FVM version
echo "FVM Version: $(fvm --version)"
echo ""

# Install Flutter stable
echo "Installing Flutter stable version..."
echo "This may take a few minutes..."
fvm install stable

echo "✓ Flutter installed successfully!"
echo ""

# Use Flutter stable for this project
echo "Configuring project to use Flutter stable..."
fvm use stable --force

echo "✓ Project configured!"
echo ""

# Verify Flutter installation
echo "Verifying Flutter installation..."
fvm flutter --version

echo ""
echo "✓ Flutter Doctor check..."
fvm flutter doctor

echo ""
echo "====================================="
echo "Setup Complete!"
echo "====================================="
echo ""
echo "Next Steps:"
echo "1. Run: fvm flutter create . --org com.preciousmetals --project-name precious_metals_app"
echo "2. Configure your IDE (see FVM-SETUP-GUIDE.md)"
echo "3. Start development!"
echo ""
echo "Useful Commands:"
echo "  fvm flutter pub get       - Install dependencies"
echo "  fvm flutter run          - Run the app"
echo "  fvm flutter test         - Run tests"
echo "  fvm flutter doctor       - Check setup"
echo ""
