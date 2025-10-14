import 'package:flutter/material.dart';

class AppConstants {
  // API Endpoints
  static const String baseUrl = 'https://api.smartcounter.app/v1';
  static const String websocketUrl = 'wss://api.smartcounter.app/v1/ws';
  static const int apiTimeout = 30000; // 30 seconds

  // Storage Keys
  static const String authTokenKey = 'auth_token';
  static const String userDataKey = 'user_data';
  static const String themePreferenceKey = 'theme_mode';
  static const String languagePreferenceKey = 'language';

  // Firebase Collections
  static const String usersCollection = 'users';
  static const String counterRoomsCollection = 'counter_rooms';
  static const String itemsCollection = 'items';
  static const String notificationsCollection = 'notifications';

  // App Settings
  static const String appName = 'Smart Counter';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';
  static const String appPackageName = 'com.xivix.smartcounter';

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double defaultMargin = 16.0;
  static const double defaultRadius = 8.0;
  static const double defaultSpacing = 8.0;
  static const double defaultElevation = 2.0;

  // Animation Durations
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration snackbarDuration = Duration(seconds: 4);
  static const Duration splashScreenDuration = Duration(seconds: 2);

  // Theme Colors
  static const Color primaryColor = Color(0xFF1565C0);
  static const Color secondaryColor = Color(0xFF00796B);
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color successColor = Color(0xFF388E3C);
  static const Color warningColor = Color(0xFFFFA000);
  static const Color infoColor = Color(0xFF0288D1);

  // Status Colors
  static const Map<String, Color> statusColors = {
    'active': Color(0xFF4CAF50),
    'pending': Color(0xFFFFA000),
    'completed': Color(0xFF2196F3),
    'cancelled': Color(0xFFE57373),
  };

  // Default Values
  static const int defaultPageSize = 20;
  static const int maxItemsPerRoom = 1000;
  static const int maxNotifications = 100;
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
  static const List<String> supportedImageTypes = ['jpg', 'jpeg', 'png', 'webp'];
  static const List<String> supportedLanguages = ['en', 'es', 'fr', 'de'];

  // Validation Constraints
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 32;
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 20;
  static const int minNameLength = 2;
  static const int maxNameLength = 50;
  static const int maxDescriptionLength = 500;
  static const int maxTitleLength = 100;

  // Error Messages
  static const String networkError = 'Please check your internet connection';
  static const String serverError = 'Something went wrong, please try again later';
  static const String authError = 'Authentication failed, please login again';
  static const String permissionError = 'You do not have permission to do this';
  static const String validationError = 'Please check your input and try again';
  static const String notFoundError = 'The requested resource was not found';

  // Success Messages
  static const String saveSuccess = 'Changes saved successfully';
  static const String deleteSuccess = 'Item deleted successfully';
  static const String updateSuccess = 'Update completed successfully';
  static const String createSuccess = 'Created successfully';

  // Navigation Routes
  static const String homeRoute = '/';
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String forgotPasswordRoute = '/forgot-password';
  static const String settingsRoute = '/settings';
  static const String profileRoute = '/profile';
  static const String notificationsRoute = '/notifications';
  static const String counterRoomsRoute = '/counter-rooms';
  static const String itemsRoute = '/items';
  static const String qrScannerRoute = '/qr-scanner';
  static const String qrGeneratorRoute = '/qr-generator';

  // Date Formats
  static const String defaultDateFormat = 'MMM dd, yyyy';
  static const String defaultTimeFormat = 'HH:mm';
  static const String defaultDateTimeFormat = 'MMM dd, yyyy HH:mm';
  static const String shortDateFormat = 'MM/dd/yy';
  static const String shortTimeFormat = 'HH:mm';

  // Cache Settings
  static const Duration defaultCacheDuration = Duration(hours: 1);
  static const int maxCacheSize = 50 * 1024 * 1024; // 50MB
  static const Duration maxCacheAge = Duration(days: 7);

  // QR Code Settings
  static const int qrCodeVersion = 7;
  static const int qrCodeSize = 300;
  static const double qrCodeBorderRadius = 10;
  static const int qrCodePadding = 20;

  // Notification Settings
  static const String notificationChannelId = 'smart_counter_notifications';
  static const String notificationChannelName = 'Smart Counter Notifications';
  static const String notificationChannelDescription =
      'Receive notifications about your counter rooms and items';

  // Image Assets
  static const String logoPath = 'assets/images/logo.png';
  static const String logoWhitePath = 'assets/images/logo_white.png';
  static const String placeholderImagePath = 'assets/images/placeholder.png';
  static const String defaultAvatarPath = 'assets/images/default_avatar.png';

  // Icon Assets
  static const String appIconPath = 'assets/icons/app_icon.png';
  static const String notificationIconPath = 'assets/icons/notification_icon.png';

  // Privacy and Terms
  static const String privacyPolicyUrl = 'https://smartcounter.app/privacy';
  static const String termsOfServiceUrl = 'https://smartcounter.app/terms';
  static const String supportUrl = 'https://smartcounter.app/support';

  // Social Media
  static const String githubUrl = 'https://github.com/XIVIX-Official/smart-counter';
  static const String twitterUrl = 'https://twitter.com/smartcounter';
  static const String linkedinUrl = 'https://linkedin.com/company/smartcounter';

  // Contact Information
  static const String supportEmail = 'support@smartcounter.app';
  static const String infoEmail = 'info@smartcounter.app';
  static const String companyAddress = 'XIVIX Technologies Inc.';
}