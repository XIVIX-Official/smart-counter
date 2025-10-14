import 'package:intl/intl.dart';

class DateFormatter {
  static final _defaultDateFormat = DateFormat('MMM dd, yyyy');
  static final _shortDateFormat = DateFormat('MMM dd');
  static final _timeFormat = DateFormat('HH:mm');
  static final _dayMonthFormat = DateFormat('d MMMM');
  static final _monthYearFormat = DateFormat('MMMM yyyy');
  static final _fullDateTimeFormat = DateFormat('MMM dd, yyyy HH:mm');

  /// Format date as 'Jan 01, 2024'
  static String formatDate(DateTime date) {
    return _defaultDateFormat.format(date);
  }

  /// Format date as 'Jan 01'
  static String formatShortDate(DateTime date) {
    return _shortDateFormat.format(date);
  }

  /// Format time as '14:30'
  static String formatTime(DateTime date) {
    return _timeFormat.format(date);
  }

  /// Format date as '1 January'
  static String formatDayMonth(DateTime date) {
    return _dayMonthFormat.format(date);
  }

  /// Format date as 'January 2024'
  static String formatMonthYear(DateTime date) {
    return _monthYearFormat.format(date);
  }

  /// Format date as 'Jan 01, 2024 14:30'
  static String formatDateTime(DateTime date) {
    return _fullDateTimeFormat.format(date);
  }

  /// Get relative time (e.g., '2 hours ago', 'yesterday', etc.)
  static String getRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      return formatDate(date);
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else if (difference.inDays > 7) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else if (difference.inDays > 0) {
      if (difference.inDays == 1) {
        return 'yesterday';
      }
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'just now';
    }
  }

  /// Get relative time in short format (e.g., '2h', '1d', etc.)
  static String getShortRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()}y';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()}mo';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'now';
    }
  }

  /// Format duration (e.g., '2h 30m', '1d 6h', etc.)
  static String formatDuration(Duration duration) {
    final days = duration.inDays;
    final hours = duration.inHours.remainder(24);
    final minutes = duration.inMinutes.remainder(60);

    if (days > 0) {
      if (hours > 0) {
        return '${days}d ${hours}h';
      }
      return '${days}d';
    } else if (hours > 0) {
      if (minutes > 0) {
        return '${hours}h ${minutes}m';
      }
      return '${hours}h';
    } else if (minutes > 0) {
      return '${minutes}m';
    } else {
      return '<1m';
    }
  }
}