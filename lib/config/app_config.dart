/// App configuration for production and development environments
class AppConfig {
  // Environment
  static const String environment = String.fromEnvironment('ENVIRONMENT', defaultValue: 'development');
  static bool get isProduction => environment == 'production';
  static bool get isDevelopment => environment == 'development';
  
  // Firebase Configuration
  static const String firebaseProjectId = String.fromEnvironment('FIREBASE_PROJECT_ID', defaultValue: 'gadget-security-dev');
  
  // Emergency Services
  static const String emergencyPhoneNumber = String.fromEnvironment('EMERGENCY_PHONE', defaultValue: '+1234567890');
  static const String securityAlertNumber = String.fromEnvironment('SECURITY_ALERT_PHONE', defaultValue: '+1234567890');
  
  // API Configuration
  static const String apiBaseUrl = String.fromEnvironment('API_BASE_URL', defaultValue: 'https://api-dev.gadgetsecurity.app');
  
  // App Metadata
  static const String appName = 'Gadget Security';
  static const String appVersion = '2.1.0';
  static const String supportEmail = 'support@gadgetsecurity.app';
  
  // Security Configuration
  static const int pinRetryLimit = 3;
  static const int sessionTimeoutMinutes = 30;
  static const bool enableBiometrics = true;
  
  // Feature Flags
  static const bool enablePeerToPeerTrading = true;
  static const bool enableEmergencyAlerts = true;
  static const bool enablePushNotifications = true;
  static const bool enableAnalytics = true;
  
  // Logging Configuration
  static bool get enableVerboseLogging => isDevelopment;
  static bool get enableCrashReporting => isProduction;
  
  // Storage Configuration
  static const String deviceImagesPath = 'device_images/';
  static const String userDocumentsPath = 'user_documents/';
  static const String profileImagesPath = 'profile_images/';
  
  // Rate Limiting
  static const int maxDevicesPerUser = 50;
  static const int maxImageSizeMB = 5;
  static const int maxDocumentSizeMB = 10;
  
  // Geographic Configuration
  static const List<String> supportedCountries = [
    'US', 'GB', 'CA', 'AU', 'DE', 'FR', 'ES', 'IT', 'NL', 'ZA'
  ];
  
  // UI Configuration
  static const int splashScreenDurationMs = 2000;
  static const int toastDurationMs = 3000;
  static const bool enableDarkMode = true;
  
  // Network Configuration
  static const int connectionTimeoutSeconds = 30;
  static const int readTimeoutSeconds = 30;
  static const int maxRetryAttempts = 3;
  
  /// Get configuration summary for debugging
  static Map<String, dynamic> getConfigSummary() {
    return {
      'environment': environment,
      'isProduction': isProduction,
      'firebaseProjectId': firebaseProjectId,
      'apiBaseUrl': apiBaseUrl,
      'appVersion': appVersion,
      'enableVerboseLogging': enableVerboseLogging,
      'enableCrashReporting': enableCrashReporting,
    };
  }
}