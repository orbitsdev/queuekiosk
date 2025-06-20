# Kiosk Project Structure

This document provides an overview of the project structure for the Kiosk application. It is intended to help team members understand the organization of the codebase, assets, and configuration files.

## Project Overview

The Kiosk project is a Flutter application with the following main directories:

- `lib/`: Contains all Dart code for the application
- `assets/`: Contains images, animations, and other resources
- `android/`, `ios/`, `macos/`, `windows/`, `web/`: Platform-specific code

## Lib Directory Structure

The `lib/` directory contains the main application code organized as follows:

```
lib/
├── controllers/     # GetX controllers for state management
│   └── sunmi_printer_controller.dart  # Sunmi thermal printer integration
├── core/            # Core functionality and services
│   ├── dio/         # Dio HTTP client configuration and services
│   ├── getx/        # GetX related core functionality
│   └── shared_preferences/ # Local storage functionality
├── middleware/      # Middleware for request/response handling
├── models/          # Data models and DTOs
├── screens/         # UI screens and pages
├── utils/           # Utility functions and helper classes
├── widgets/         # Reusable UI components
└── main.dart        # Application entry point
```

### Core Components

The `core/` directory contains essential services and configurations:

- **dio/**: HTTP client configuration for API communication
  - `app_string.dart`: String constants for API endpoints
  - `data_source.dart`: Data source implementations
  - `dio_service.dart`: Dio client service implementation
  - `response_messages.dart`: Standard response message handling
  - `type_def.dart`: Type definitions for API responses

- **getx/**: GetX framework related core functionality
- **shared_preferences/**: Local storage implementation using SharedPreferences

### Controllers

The `controllers/` directory contains GetX controllers for state management:

- **sunmi_printer_controller.dart**: Integration with Sunmi thermal printer hardware for printing receipts, tickets, and QR codes

## Assets Directory

The `assets/` directory contains resources used by the application:

```
assets/
├── animations/      # Lottie animation JSON files
│   ├── empty.json
│   ├── empty_state.json
│   ├── error.json
│   ├── loading_animation.json
│   ├── no-internet.json
│   ├── questionmark.json
│   ├── success.json
│   └── success_animation.json
└── images/          # Image assets
    └── app_logo.png
```

### Animations

The application uses Lottie animations stored as JSON files in the `animations/` directory. These animations are used for various states like loading, success, error, and empty states.

### Images

The `images/` directory contains static image assets used throughout the application, including the app logo.

## Platform-Specific Directories

- `android/`: Android-specific code and configuration
- `ios/`: iOS-specific code and configuration
- `macos/`: macOS-specific code and configuration
- `windows/`: Windows-specific code and configuration
- `web/`: Web-specific code and configuration, including web manifest

## Configuration Files

- `pubspec.yaml`: Flutter dependencies and asset declarations
- `web/manifest.json`: Web application manifest for PWA support

## How to Use This Document

This document should be updated whenever significant changes are made to the project structure. Team members should refer to this document to understand where to place new files and how existing code is organized.

When adding new features:
- Place UI components in the appropriate directories under `lib/screens/` or `lib/widgets/`
- Add new models to `lib/models/`
- Place business logic in controllers under `lib/controllers/`
- Add utility functions to `lib/utils/`
- Place new assets in the appropriate subdirectory under `assets/`
