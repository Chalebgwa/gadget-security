import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:gsec/config/app_config.dart';

/// Production-ready logging service with different log levels
class AppLogger {
  static const String _tag = 'GadgetSecurity';
  
  /// Log levels
  enum LogLevel {
    debug,
    info,
    warning,
    error,
    critical,
  }
  
  /// Log debug information (only in development)
  static void debug(String message, {Object? error, StackTrace? stackTrace}) {
    if (!AppConfig.enableVerboseLogging) return;
    _log(LogLevel.debug, message, error: error, stackTrace: stackTrace);
  }
  
  /// Log general information
  static void info(String message, {Object? error}) {
    _log(LogLevel.info, message, error: error);
  }
  
  /// Log warnings
  static void warning(String message, {Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.warning, message, error: error, stackTrace: stackTrace);
  }
  
  /// Log errors
  static void error(String message, {Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.error, message, error: error, stackTrace: stackTrace);
    
    // In production, send to crash reporting service
    if (AppConfig.enableCrashReporting && error != null) {
      _reportToCrashlytics(message, error, stackTrace);
    }
  }
  
  /// Log critical errors that require immediate attention
  static void critical(String message, {Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.critical, message, error: error, stackTrace: stackTrace);
    
    // Always report critical errors
    if (error != null) {
      _reportToCrashlytics(message, error, stackTrace);
    }
  }
  
  /// Internal logging method
  static void _log(
    LogLevel level,
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    final timestamp = DateTime.now().toIso8601String();
    final levelString = level.name.toUpperCase();
    final logMessage = '[$timestamp] [$_tag] [$levelString] $message';
    
    if (kDebugMode) {
      // In debug mode, use developer.log for better debugging
      developer.log(
        message,
        name: _tag,
        error: error,
        stackTrace: stackTrace,
        level: _getLevelValue(level),
      );
    } else {
      // In release mode, use print for basic logging
      print(logMessage);
      if (error != null) {
        print('Error: $error');
      }
      if (stackTrace != null) {
        print('Stack trace: $stackTrace');
      }
    }
  }
  
  /// Get numeric level value for developer.log
  static int _getLevelValue(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return 500;
      case LogLevel.info:
        return 800;
      case LogLevel.warning:
        return 900;
      case LogLevel.error:
        return 1000;
      case LogLevel.critical:
        return 1200;
    }
  }
  
  /// Report to crash reporting service (placeholder for Firebase Crashlytics)
  static void _reportToCrashlytics(String message, Object error, StackTrace? stackTrace) {
    // TODO: Integrate with Firebase Crashlytics
    // FirebaseCrashlytics.instance.recordError(error, stackTrace, reason: message);
    
    // For now, just log it
    if (kDebugMode) {
      print('CRASH REPORT: $message - Error: $error');
    }
  }
  
  /// Log authentication events
  static void logAuth(String event, {String? userId, Object? error}) {
    final message = 'Auth Event: $event${userId != null ? ' (User: $userId)' : ''}';
    if (error != null) {
      error('Auth Error: $message', error: error);
    } else {
      info(message);
    }
  }
  
  /// Log device operations
  static void logDevice(String operation, {String? deviceId, Object? error}) {
    final message = 'Device Operation: $operation${deviceId != null ? ' (Device: $deviceId)' : ''}';
    if (error != null) {
      error('Device Error: $message', error: error);
    } else {
      info(message);
    }
  }
  
  /// Log security events
  static void logSecurity(String event, {String? userId, bool isCritical = false}) {
    final message = 'Security Event: $event${userId != null ? ' (User: $userId)' : ''}';
    if (isCritical) {
      critical(message);
    } else {
      warning(message);
    }
  }
  
  /// Log payment/transaction events
  static void logPayment(String event, {String? transactionId, Object? error}) {
    final message = 'Payment Event: $event${transactionId != null ? ' (Transaction: $transactionId)' : ''}';
    if (error != null) {
      error('Payment Error: $message', error: error);
    } else {
      info(message);
    }
  }
  
  /// Log navigation events (for analytics)
  static void logNavigation(String screen, {String? userId}) {
    if (!AppConfig.enableAnalytics) return;
    final message = 'Navigation: $screen${userId != null ? ' (User: $userId)' : ''}';
    debug(message);
  }
  
  /// Log performance metrics
  static void logPerformance(String metric, Duration duration) {
    if (!AppConfig.enableVerboseLogging) return;
    debug('Performance: $metric took ${duration.inMilliseconds}ms');
  }
  
  /// Log app lifecycle events
  static void logAppLifecycle(String event) {
    info('App Lifecycle: $event');
  }
}