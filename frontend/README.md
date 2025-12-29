# Precious Metals Social Platform - Mobile App

Cross-platform mobile application built with Flutter for tracking precious metals and forex with social features.

## Prerequisites

- Windows 10/11
- Git
- Flutter SDK (already installed)

## Flutter Environment Setup

### Current Installation

Flutter 3.24.5 has been installed at `C:\Users\12117\flutter` using the Chinese mirror.

**Environment Variables (Already Set):**
```
PUB_HOSTED_URL=https://pub.flutter-io.cn
FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
PATH includes C:\Users\12117\flutter\bin
PATH includes C:\Users\12117\AppData\Local\Pub\Cache\bin
```

### About FVM (Flutter Version Manager)

This project includes FVM configuration files (`.fvmrc`) for team consistency. However, due to the drive's exFAT file system limitation (no symbolic link support), FVM cannot be used directly on this drive.

**Options:**
1. **Use Global Flutter** (Current Approach): Use the installed Flutter directly with `flutter` commands
2. **Move to NTFS Drive**: Move the project to an NTFS drive to enable FVM with full symlink support
3. **Use FVM without symlinks**: Use `fvm flutter` commands which work without symlinks

For detailed FVM setup instructions, see `FVM-SETUP-GUIDE.md`.

## Quick Start

### Option 1: Using Global Flutter (Recommended for Current Setup)

Initialize the Flutter project:

```powershell
cd D:\Playground\gold\frontend
flutter create . --org com.preciousmetals --project-name precious_metals_app
```

Run the app:
```powershell
flutter run
```

### Option 2: Using FVM (If Available)

If FVM is installed, you can use it without symlinks:

```powershell
# One-time setup
fvm install stable
fvm use stable --force

# Use FVM commands
fvm flutter create . --org com.preciousmetals --project-name precious_metals_app
fvm flutter run
```

Or run the setup script:
```powershell
# PowerShell
.\setup-fvm.ps1

# Git Bash / WSL
./setup-fvm.sh
```

## Development Commands

### Using Global Flutter
```powershell
flutter pub get          # Install dependencies
flutter run             # Run the app
flutter test            # Run tests
flutter build apk       # Build Android APK
flutter doctor          # Check Flutter installation
```

### Using FVM (Optional)
Prefix all commands with `fvm`:
```powershell
fvm flutter pub get     # Install dependencies
fvm flutter run         # Run the app
fvm flutter test        # Run tests
```

## Project Structure

```
frontend/
├── lib/
│   ├── core/           # Shared utilities, constants, themes
│   ├── data/           # Repositories, API clients, models
│   ├── features/       # Feature modules
│   │   ├── home/       # Home page with market overview
│   │   ├── quotes/     # Quotes list page
│   │   ├── forex/      # Forex calculator page
│   │   ├── community/  # Community & predictions
│   │   └── profile/    # User profile & settings
│   └── widgets/        # Reusable UI components
├── test/               # Widget and unit tests
├── android/            # Android platform code
├── ios/                # iOS platform code
└── pubspec.yaml        # Dart/Flutter dependencies
```

## Flutter Version

This project uses **Flutter 3.24.5**.

To check current version:
```powershell
flutter --version
```

## IDE Setup

### VS Code

Install the following extensions:
- Flutter
- Dart

The `.vscode/settings.json` is already configured with the Flutter SDK path.

### Android Studio

1. Go to Settings > Languages & Frameworks > Flutter
2. Set Flutter SDK path to: `C:\Users\12117\flutter`

## Note on FVM

FVM (Flutter Version Manager) is installed but cannot create symbolic links on this drive because it uses exFAT file system. The global Flutter installation is used instead.

If you move this project to an NTFS drive, you can use FVM:
```powershell
fvm use 3.24.5
fvm flutter run
```
