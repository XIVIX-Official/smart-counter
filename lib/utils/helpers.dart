import 'dart:math';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:uuid/uuid.dart';

class Helpers {
  static final _uuid = Uuid();
  static final _random = Random();

  /// Generate a unique ID
  static String generateId() {
    return _uuid.v4();
  }

  /// Generate a random QR code
  static String generateQrCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return List.generate(
        10, (index) => chars[_random.nextInt(chars.length)]).join();
  }

  /// Check internet connectivity
  static Future<bool> isConnected() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  /// Format file size
  static String formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      final kb = bytes / 1024;
      return '${kb.toStringAsFixed(1)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      final mb = bytes / (1024 * 1024);
      return '${mb.toStringAsFixed(1)} MB';
    } else {
      final gb = bytes / (1024 * 1024 * 1024);
      return '${gb.toStringAsFixed(1)} GB';
    }
  }

  /// Format large numbers with suffixes (K, M, B)
  static String formatNumber(num number) {
    if (number < 1000) {
      return number.toString();
    } else if (number < 1000000) {
      final k = number / 1000;
      return '${k.toStringAsFixed(1)}K';
    } else if (number < 1000000000) {
      final m = number / 1000000;
      return '${m.toStringAsFixed(1)}M';
    } else {
      final b = number / 1000000000;
      return '${b.toStringAsFixed(1)}B';
    }
  }

  /// Capitalize the first letter of a string
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  /// Convert camelCase to Title Case
  static String camelCaseToTitleCase(String text) {
    if (text.isEmpty) return text;
    return text.replaceAllMapped(
      RegExp(r'[A-Z]'),
      (match) => ' ${match.group(0)}',
    ).trim().toUpperCase();
  }

  /// Convert snake_case to Title Case
  static String snakeCaseToTitleCase(String text) {
    if (text.isEmpty) return text;
    return text.split('_').map((word) => capitalize(word)).join(' ');
  }

  /// Get color hex value from string
  static int getColorFromString(String text) {
    var hash = 0;
    for (var i = 0; i < text.length; i++) {
      hash = text.codeUnitAt(i) + ((hash << 5) - hash);
    }
    final color = (hash & 0x00FFFFFF).toRadixString(16).padLeft(6, '0');
    return int.parse('0xFF$color');
  }

  /// Check if a string is a valid URL
  static bool isValidUrl(String url) {
    return Uri.tryParse(url)?.hasAbsolutePath ?? false;
  }

  /// Get file extension from path
  static String getFileExtension(String path) {
    return path.split('.').last;
  }

  /// Check if a file is an image
  static bool isImageFile(String path) {
    final ext = getFileExtension(path).toLowerCase();
    return ['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(ext);
  }

  /// Generate a random hex color
  static String getRandomColor() {
    return '${_random.nextInt(0xFFFFFF).toRadixString(16).padLeft(6, '0')}';
  }

  /// Calculate percentage
  static double calculatePercentage(num value, num total) {
    if (total == 0) return 0;
    return (value / total) * 100;
  }

  /// Truncate text with ellipsis
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  /// Check if a string contains only numbers
  static bool isNumeric(String text) {
    return RegExp(r'^[0-9]+$').hasMatch(text);
  }

  /// Generate a random string
  static String generateRandomString([int length = 10]) {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return List.generate(
        length, (index) => chars[_random.nextInt(chars.length)]).join();
  }

  /// Extract domain from URL
  static String? extractDomain(String url) {
    final uri = Uri.tryParse(url);
    return uri?.host;
  }

  /// Convert a hex color string to an integer
  static int hexToInt(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    return int.parse(hex, radix: 16);
  }

  /// Convert error to user-friendly message
  static String getErrorMessage(dynamic error) {
    if (error is String) return error;
    return error?.toString() ?? 'An unknown error occurred';
  }

  /// Check if a date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Check if a date is yesterday
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  /// Get the difference between two dates in days
  static int getDaysDifference(DateTime date1, DateTime date2) {
    return date1.difference(date2).inDays;
  }

  /// Get the first letters of each word in a string
  static String getInitials(String text) {
    if (text.isEmpty) return '';
    return text
        .trim()
        .split(' ')
        .where((word) => word.isNotEmpty)
        .map((word) => word[0])
        .join()
        .toUpperCase();
  }

  /// Retry a function with delay
  static Future<T> retry<T>(
    Future<T> Function() fn, {
    int maxAttempts = 3,
    Duration delay = const Duration(seconds: 1),
  }) async {
    var attempts = 0;
    while (true) {
      try {
        attempts++;
        return await fn();
      } catch (e) {
        if (attempts >= maxAttempts) {
          rethrow;
        }
        await Future.delayed(delay);
      }
    }
  }

  /// Deep merge two maps
  static Map<String, dynamic> deepMerge(
    Map<String, dynamic> map1,
    Map<String, dynamic> map2,
  ) {
    final result = Map<String, dynamic>.from(map1);

    map2.forEach((key, value) {
      if (value is Map<String, dynamic> && result[key] is Map<String, dynamic>) {
        result[key] = deepMerge(result[key] as Map<String, dynamic>, value);
      } else {
        result[key] = value;
      }
    });

    return result;
  }
}