# Kiosk Project Structure

This document provides a comprehensive overview of the project structure for the Kiosk application. It is intended to help team members understand the organization of the codebase, assets, and configuration files.

## Project Overview

The Kiosk project is a Flutter application with the following main directories:

- `lib/`: Contains all Dart code for the application
- `assets/`: Contains images, animations, and other resources
- `android/`, `ios/`, `macos/`, `windows/`, `web/`: Platform-specific code

## Lib Directory Structure

The `lib/` directory contains the main application code organized as follows:

```
lib/
├── controllers/                    # GetX controllers for state management
│   ├── kiosk_controller.dart       # Main kiosk functionality controller
│   └── sunmi_printer_controller.dart # Sunmi thermal printer integration
├── core/                           # Core functionality and services
│   ├── dio/                        # Dio HTTP client configuration and services
│   │   ├── app_string.dart         # String constants for API endpoints
│   │   ├── data_source.dart        # Data source implementations
│   │   ├── dio_service.dart        # Dio client service implementation
│   │   ├── response_codes.dart     # HTTP response codes
│   │   ├── response_messages.dart  # Standard response message handling
│   │   └── type_def.dart           # Type definitions for API responses
│   ├── getx/                       # GetX related core functionality
│   │   └── app_binding.dart        # GetX dependency injection bindings
│   └── shared_preferences/         # Local storage functionality
│       └── shared_preference_manager.dart # SharedPreferences manager
├── examples/                       # Example code for reference
│   └── sumni_example_print.dart    # Example implementation of Sunmi printer
├── middleware/                     # Middleware for request/response handling
│   ├── branch_middeware.dart       # Branch-specific middleware
│   └── no_branch_middleware.dart   # Middleware for no branch scenario
├── models/                         # Data models and DTOs
│   ├── branch.dart                 # Branch model
│   ├── failure.dart                # Failure model for error handling
│   ├── queue.dart                  # Queue model
│   ├── service.dart                # Service model
│   └── settings.dart               # Settings model
├── screens/                        # UI screens and pages
│   ├── branch_code_screen.dart     # Branch code entry screen
│   ├── not_authorize_screen.dart   # Unauthorized access screen
│   ├── print_screen.dart           # Printing functionality screen
│   └── services_screen.dart        # Available services screen
├── utils/                          # Utility functions and helper classes
│   ├── app_color_pallete.dart      # Color palette definitions
│   └── app_theme.dart              # Application theme configuration
├── widgets/                        # Reusable UI components
│   ├── empty_state_widget.dart     # Widget for empty state display
│   ├── local_lottie_image.dart     # Lottie animation wrapper widget
│   ├── modal.dart                  # Modal dialog component
│   └── service_card_widget.dart    # Service card UI component
└── main.dart                       # Application entry point
```

### Controllers

The `controllers/` directory contains GetX controllers for state management:

- **kiosk_controller.dart**: Main controller for kiosk functionality and business logic
- **sunmi_printer_controller.dart**: Integration with Sunmi thermal printer hardware for printing receipts, tickets, and QR codes
  - Manages guest information and room details using reactive variables (RxMap, RxInt)
  - Provides methods for printing guest receipts and test prints
  - Handles printer initialization, printing, and error handling
  - Includes helper methods for formatting floor numbers (1st, 2nd, 3rd, etc.)
  - Implements modular printing functions for logo, header, guest info, QR codes, and footer

### Core Components

The `core/` directory contains essential services and configurations:

- **dio/**: HTTP client configuration for API communication
  - `app_string.dart`: String constants for API endpoints and URLs
  - `data_source.dart`: Data source implementations for API interactions
  - `dio_service.dart`: Dio HTTP client service implementation with interceptors
  - `response_codes.dart`: HTTP response code definitions and handling
  - `response_messages.dart`: Standard response message handling and formatting
  - `type_def.dart`: Type definitions for API responses and callbacks

- **getx/**: GetX framework related core functionality
  - `app_binding.dart`: Dependency injection bindings for GetX controllers

- **shared_preferences/**: Local storage implementation using SharedPreferences
  - `shared_preference_manager.dart`: Manager for storing and retrieving local data

### Examples

The `examples/` directory contains reference implementations:

- **sumni_example_print.dart**: Example code for Sunmi printer integration and usage

### Middleware

The `middleware/` directory contains request/response handling middleware:

- **branch_middeware.dart**: Middleware for branch-specific functionality
- **no_branch_middleware.dart**: Middleware for handling scenarios without branch information

### Models

The `models/` directory contains data models and DTOs:

- **branch.dart**: Model for branch data
- **failure.dart**: Model for error handling and failure states
- **queue.dart**: Model for queue management
- **service.dart**: Model for available services
- **settings.dart**: Model for application settings

### Screens

The `screens/` directory contains UI screens and pages:

- **branch_code_screen.dart**: Screen for entering branch codes
- **not_authorize_screen.dart**: Screen displayed when user is not authorized
- **print_screen.dart**: Screen for printing functionality
- **services_screen.dart**: Screen displaying available services

### Utils

The `utils/` directory contains utility functions and helper classes:

- **app_color_pallete.dart**: Color definitions for consistent UI
- **app_theme.dart**: Theme configuration for the application

### Widgets

The `widgets/` directory contains reusable UI components:

- **empty_state_widget.dart**: Widget for displaying empty states
- **local_lottie_image.dart**: Widget for displaying Lottie animations
- **modal.dart**: Reusable modal dialog component
- **service_card_widget.dart**: Card widget for displaying services

## Assets Directory

The `assets/` directory contains resources used by the application:

```
assets/
├── animations/                  # Lottie animation JSON files
│   ├── empty.json              # Empty state animation
│   ├── empty_state.json        # Alternative empty state animation
│   ├── error.json              # Error state animation
│   ├── loading_animation.json  # Loading state animation
│   ├── no-internet.json        # No internet connection animation
│   ├── questionmark.json       # Question/help animation
│   ├── success.json            # Success state animation
│   └── success_animation.json  # Alternative success animation
└── images/                     # Image assets
    └── app_logo.png            # Application logo
```

### Animations

The application uses Lottie animations stored as JSON files in the `animations/` directory. These animations are used for various states like loading, success, error, and empty states.

### Images

The `images/` directory contains static image assets used throughout the application, including the app logo used in the UI and for printing receipts.

## Platform-Specific Directories

- `android/`: Android-specific code and configuration
  - Contains Java/Kotlin code, resource files, and Android manifest
  - Includes configuration for Gradle build system:
    - `android/app/build.gradle.kts`: App-specific build configuration
      ```kotlin
      defaultConfig {
          applicationId = "com.example.kiosk"
          minSdk = 21
          targetSdk = 28
          versionCode = flutter.versionCode
          versionName = flutter.versionName
      }
      ```
    - `android/settings.gradle.kts`: Project-level Gradle settings
      ```kotlin
      plugins {
          id("dev.flutter.flutter-plugin-loader") version "1.0.0"
          id("com.android.application") version "8.3.0" apply false
          id("org.jetbrains.kotlin.android") version "1.9.10" apply false
      }
      
      include(":app")
      ```

- `ios/`: iOS-specific code and configuration
  - Contains Swift/Objective-C code, Xcode project files
  - Includes asset catalogs and storyboards

- `macos/`: macOS-specific code and configuration
  - Contains macOS app configuration and resources
  - Includes Xcode project files for macOS target

- `windows/`: Windows-specific code and configuration
  - Contains C++ code for Windows platform integration
  - Includes resource files and runner implementation

- `web/`: Web-specific code and configuration
  - Contains HTML, CSS, and JavaScript files
  - Includes web manifest and icons for PWA support

## Configuration Files

### YAML Files

- `pubspec.yaml`: Flutter dependencies and asset declarations
  - Defines project dependencies and versions:
    - Flutter SDK: ^3.7.2
    - GetX: ^4.7.2 (state management)
    - Dio: ^5.8.0+1 (HTTP client)
    - Shared Preferences: ^2.5.3 (local storage)
    - Lottie: ^3.3.1 (animations)
    - QR Flutter: ^4.1.0 (QR code generation)
    - Sunmi Printer Plus: ^4.1.0 (thermal printer integration)
    - Other UI packages: heroicons, flutter_svg, flutter_animate, etc.
  - Configures asset paths:
    ```yaml
    assets:
      - assets/animations/
      - assets/images/
    ```
  - Specifies Flutter SDK constraints and environment settings
  - Configures app version (1.0.0+1)

- `analysis_options.yaml`: Dart analyzer configuration
  - Includes Flutter lints package for code quality
  - Configures linting rules for the project
  - Helps maintain consistent code style across the team

### JSON Files

- `web/manifest.json`: Web application manifest for PWA support
  - Defines app name, icons, and theme colors
  - Configures display mode and orientation
  - Sets up web app capabilities

## How to Use This Document

This document should be updated whenever significant changes are made to the project structure. Team members should refer to this document to understand where to place new files and how existing code is organized.

When adding new features:
- Place UI components in the appropriate directories under `lib/screens/` or `lib/widgets/`
- Add new models to `lib/models/`
- Place business logic in controllers under `lib/controllers/`
- Add utility functions to `lib/utils/`
- Place new assets in the appropriate subdirectory under `assets/`

### Sunmi Printer Integration

The Sunmi printer integration is handled by the `sunmi_printer_controller.dart` file in the `controllers/` directory. This controller provides methods for:

1. Printing guest receipts with room information
2. Generating QR codes for room access
3. Test printing to verify printer functionality
4. Managing guest and room data for printing

When working with the printer functionality, refer to the example implementation in `examples/sumni_example_print.dart` for guidance.
