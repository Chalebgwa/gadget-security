import 'package:flutter/material.dart';
import 'package:gsec/config/app_config.dart';
import 'package:gsec/utils/app_logger.dart';

/// Production-ready error handling widget
class AppErrorHandler extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final bool showDetails;

  const AppErrorHandler({
    super.key,
    required this.message,
    this.onRetry,
    this.showDetails = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Oops! Something went wrong',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              showDetails ? message : 'We encountered an unexpected error. Please try again.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            if (onRetry != null) ...[
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
            ],
            TextButton(
              onPressed: () {
                // TODO: Implement feedback/support functionality
                AppLogger.info('User requested support for error: $message');
              },
              child: const Text('Contact Support'),
            ),
            if (AppConfig.isDevelopment && showDetails) ...[
              const SizedBox(height: 16),
              ExpansionTile(
                title: const Text('Error Details (Debug)'),
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      message,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Global error handler for uncaught exceptions
class GlobalErrorHandler {
  static void initialize() {
    // Handle Flutter framework errors
    FlutterError.onError = (FlutterErrorDetails details) {
      AppLogger.critical(
        'Flutter error: ${details.exception}',
        error: details.exception,
        stackTrace: details.stack,
      );
      
      if (AppConfig.isProduction) {
        // In production, report to crash reporting service
        // TODO: Integrate with Firebase Crashlytics
      }
    };
  }
  
  /// Show error dialog for recoverable errors
  static void showErrorDialog(BuildContext context, String message, {VoidCallback? onRetry}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.error_outline, color: Theme.of(context).colorScheme.error),
            const SizedBox(width: 8),
            const Text('Error'),
          ],
        ),
        content: Text(message),
        actions: [
          if (onRetry != null)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onRetry();
              },
              child: const Text('Retry'),
            ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
  
  /// Show error snackbar for minor errors
  static void showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        duration: Duration(milliseconds: AppConfig.toastDurationMs),
      ),
    );
  }
}