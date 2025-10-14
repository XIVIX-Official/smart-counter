# Smart Counter

A modern mobile and web application for efficiently managing counter rooms, tracking items, and handling real-time notifications through QR code technology. Built with Flutter to provide a seamless cross-platform experience.

## 🌟 Features

- **QR Code Management**: Generate, scan, and manage QR codes for items and counter rooms
- **Cross-Platform Support**: Native mobile (iOS/Android) and web applications from a single codebase
- **Real-Time Notifications**: Instant alerts for item updates, counter events, and user actions
- **Item Tracking**: Comprehensive inventory management with status monitoring
- **Counter Room Management**: Organize and manage multiple counter stations efficiently
- **Offline Support**: Work seamlessly even without internet connectivity
- **Dashboard Analytics**: Visual insights into counter operations and item statistics
- **User Management**: Role-based access control for different user types
- **Search & Filter**: Advanced search capabilities for quick item and room lookups

## 🚀 Quick Start

### Prerequisites

- Flutter SDK (v3.0.0 or higher)
- Dart SDK (v2.20.0 or higher)
- For iOS: Xcode 14+ and Cocoapods
- For Android: Android Studio or Android SDK
- A code editor (VS Code or Android Studio recommended)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/XIVIX-Official/smart-counter.git
   cd smart-counter
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure your environment**
   - Copy `.env.example` to `.env`
   - Update configuration with your API endpoints and settings

4. **Run the application**
   ```bash
   # For development
   flutter run

   # For web
   flutter run -d chrome

   # For iOS (requires macOS)
   flutter run -d ios

   # For Android
   flutter run -d android
   ```

## 📁 Project Structure

```
smart-counter/
├── lib/
│   ├── main.dart                      # App entry point
│   ├── config/                        # Configuration files
│   │   ├── app_config.dart           # App configuration settings
│   │   ├── api_config.dart           # API endpoint configuration
│   │   └── theme_config.dart         # Theme and styling configuration
│   ├── models/                        # Data models
│   │   ├── counter_room.dart         # Counter room model
│   │   ├── item.dart                 # Item model
│   │   ├── notification.dart         # Notification model
│   │   ├── user.dart                 # User model
│   │   └── qr_code.dart              # QR code model
│   ├── services/                      # Business logic and services
│   │   ├── auth_service.dart         # Authentication service
│   │   ├── item_service.dart         # Item management service
│   │   ├── counter_service.dart      # Counter room service
│   │   ├── qr_service.dart           # QR code scanning/generation
│   │   ├── notification_service.dart # Push notifications
│   │   ├── storage_service.dart      # Local storage management
│   │   └── api_service.dart          # API communication
│   ├── controllers/                   # State management
│   │   ├── auth_controller.dart      # Authentication state
│   │   ├── item_controller.dart      # Item state management
│   │   ├── counter_controller.dart   # Counter state management
│   │   ├── notification_controller.dart # Notification state
│   │   └── qr_controller.dart        # QR code state
│   ├── screens/                       # UI screens
│   │   ├── auth/
│   │   │   ├── login_screen.dart
│   │   │   ├── register_screen.dart
│   │   │   └── forgot_password_screen.dart
│   │   ├── home/
│   │   │   ├── home_screen.dart
│   │   │   └── dashboard_screen.dart
│   │   ├── counter/
│   │   │   ├── counter_list_screen.dart
│   │   │   ├── counter_detail_screen.dart
│   │   │   └── counter_create_screen.dart
│   │   ├── items/
│   │   │   ├── item_list_screen.dart
│   │   │   ├── item_detail_screen.dart
│   │   │   ├── item_create_screen.dart
│   │   │   └── item_edit_screen.dart
│   │   ├── qr/
│   │   │   ├── qr_scanner_screen.dart
│   │   │   ├── qr_generator_screen.dart
│   │   │   └── qr_history_screen.dart
│   │   ├── notifications/
│   │   │   ├── notification_list_screen.dart
│   │   │   └── notification_detail_screen.dart
│   │   └── settings/
│   │       ├── settings_screen.dart
│   │       └── profile_screen.dart
│   ├── widgets/                       # Reusable UI components
│   │   ├── custom_app_bar.dart
│   │   ├── custom_button.dart
│   │   ├── item_card.dart
│   │   ├── counter_card.dart
│   │   ├── notification_tile.dart
│   │   ├── bottom_navigation_bar.dart
│   │   └── loading_widget.dart
│   ├── utils/                         # Utility functions
│   │   ├── constants.dart            # App constants
│   │   ├── validators.dart           # Input validation
│   │   ├── logger.dart               # Logging utility
│   │   ├── formatters.dart           # Data formatting
│   │   └── helpers.dart              # Helper functions
│   └── exceptions/                    # Custom exceptions
│       ├── app_exception.dart
│       └── api_exception.dart
├── test/                              # Unit and widget tests
│   ├── services/
│   ├── controllers/
│   └── widgets/
├── assets/
│   ├── images/                        # App images
│   ├── icons/                         # App icons
│   └── fonts/                         # Custom fonts
├── android/                           # Android-specific files
├── ios/                               # iOS-specific files
├── web/                               # Web-specific files
├── windows/                           # Windows-specific files (optional)
├── macos/                             # macOS-specific files (optional)
├── linux/                             # Linux-specific files (optional)
├── pubspec.yaml                       # Flutter dependencies
├── pubspec.lock                       # Locked dependency versions
├── .env.example                       # Environment variables template
├── .gitignore                         # Git ignore rules
├── LICENSE                            # License file
└── README.md                          # This file
```

## 🛠 Technology Stack

- **Frontend**: Flutter, Dart
- **State Management**: GetX / Provider / Riverpod (choose one based on project preference)
- **QR Code**: qr_flutter, qr_code_scanner
- **Notifications**: firebase_messaging, local_notifications
- **API Communication**: dio, http
- **Local Storage**: hive, shared_preferences, sqflite
- **Authentication**: firebase_auth, jwt_decoder
- **UI Components**: material_design, cupertino_icons
- **Testing**: flutter_test, mockito

## 📚 Key Dependencies

Check `pubspec.yaml` for the complete list of dependencies:

```yaml
dependencies:
  flutter:
    sdk: flutter
  # State Management
  get: ^latest
  # QR Code Operations
  qr_flutter: ^latest
  qr_code_scanner: ^latest
  # Notifications
  firebase_messaging: ^latest
  flutter_local_notifications: ^latest
  # API & Networking
  dio: ^latest
  # Local Storage
  hive: ^latest
  shared_preferences: ^latest
  # Authentication
  firebase_auth: ^latest
  # Others
  intl: ^latest
  cached_network_image: ^latest
```

## 🎯 Development Workflow

### 1. **Setup Development Environment**
   - Install all dependencies: `flutter pub get`
   - Configure Firebase (if using Firebase services)
   - Setup environment variables in `.env` file

### 2. **Create Feature Branches**
   ```bash
   git checkout -b feature/feature-name
   git checkout -b bugfix/bug-name
   ```

### 3. **Code Standards**
   - Follow Dart style guide
   - Run static analysis: `flutter analyze`
   - Format code: `flutter format .`
   - Create meaningful commit messages

### 4. **Testing**
   ```bash
   # Run all tests
   flutter test

   # Run tests with coverage
   flutter test --coverage
   ```

### 5. **Build for Production**
   ```bash
   # Web
   flutter build web --release

   # Android
   flutter build apk --release
   flutter build appbundle --release

   # iOS
   flutter build ios --release
   ```

## 📖 Documentation

- **API Documentation**: See `/docs/API.md` for API endpoint details
- **Architecture Guide**: See `/docs/ARCHITECTURE.md` for system design

## 🔐 Security

- Never commit sensitive data (API keys, credentials)
- Use environment variables for configuration
- Report security vulnerabilities responsibly

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 💬 Community

- **Discussions**: GitHub Discussions
- **Issues**: GitHub Issues
- **Slack**: [Join our community Slack]
- **Email**: info@codexustechnologies.com

## 📞 Support

For support, reach out to:
- GitHub Issues
- Email: info@codexustechnologies.com

---

**Powered by XIVIX**