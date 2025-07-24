import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:gsec/config/app_config.dart';
import 'package:gsec/utils/app_logger.dart';

/// Performance monitoring service for production
class PerformanceMonitor {
  static final Map<String, DateTime> _startTimes = {};
  static final Map<String, List<Duration>> _metrics = {};
  
  /// Start timing an operation
  static void startTimer(String operation) {
    if (!AppConfig.enableVerboseLogging && !AppConfig.isProduction) return;
    _startTimes[operation] = DateTime.now();
  }
  
  /// Stop timing an operation and log the result
  static Duration? stopTimer(String operation) {
    if (!_startTimes.containsKey(operation)) return null;
    
    final startTime = _startTimes.remove(operation)!;
    final duration = DateTime.now().difference(startTime);
    
    // Store metric for analysis
    _metrics.putIfAbsent(operation, () => []).add(duration);
    
    // Log performance
    AppLogger.logPerformance(operation, duration);
    
    // Alert on slow operations
    if (duration.inMilliseconds > 5000) {  // 5 seconds
      AppLogger.warning('Slow operation detected: $operation took ${duration.inMilliseconds}ms');
    }
    
    return duration;
  }
  
  /// Monitor async operation
  static Future<T> monitorAsync<T>(
    String operation,
    Future<T> Function() task,
  ) async {
    startTimer(operation);
    try {
      final result = await task();
      stopTimer(operation);
      return result;
    } catch (e) {
      stopTimer(operation);
      AppLogger.error('Error in monitored operation: $operation', error: e);
      rethrow;
    }
  }
  
  /// Monitor sync operation
  static T monitorSync<T>(
    String operation,
    T Function() task,
  ) {
    startTimer(operation);
    try {
      final result = task();
      stopTimer(operation);
      return result;
    } catch (e) {
      stopTimer(operation);
      AppLogger.error('Error in monitored operation: $operation', error: e);
      rethrow;
    }
  }
  
  /// Get performance statistics
  static Map<String, Map<String, dynamic>> getStats() {
    final stats = <String, Map<String, dynamic>>{};
    
    for (final entry in _metrics.entries) {
      final durations = entry.value;
      if (durations.isEmpty) continue;
      
      final milliseconds = durations.map((d) => d.inMilliseconds).toList()..sort();
      
      stats[entry.key] = {
        'count': durations.length,
        'average': milliseconds.reduce((a, b) => a + b) / milliseconds.length,
        'min': milliseconds.first,
        'max': milliseconds.last,
        'p50': _percentile(milliseconds, 0.5),
        'p90': _percentile(milliseconds, 0.9),
        'p95': _percentile(milliseconds, 0.95),
        'p99': _percentile(milliseconds, 0.99),
      };
    }
    
    return stats;
  }
  
  /// Calculate percentile
  static double _percentile(List<int> values, double percentile) {
    if (values.isEmpty) return 0;
    
    final index = (values.length * percentile).floor();
    return values[index.clamp(0, values.length - 1)].toDouble();
  }
  
  /// Clear all metrics
  static void clearStats() {
    _metrics.clear();
    _startTimes.clear();
  }
  
  /// Log memory usage
  static void logMemoryUsage(String context) {
    if (!AppConfig.enableVerboseLogging) return;
    
    // This is a placeholder - actual memory monitoring would require platform-specific code
    AppLogger.debug('Memory check at: $context');
  }
  
  /// Monitor frame rendering (for UI performance)
  static void monitorFrameRate() {
    if (!AppConfig.enableVerboseLogging) return;
    
    // Monitor frame rate for UI performance
    WidgetsBinding.instance.addPersistentFrameCallback((timeStamp) {
      // This would be expanded to actually measure frame rate
      // For now, just log frame callbacks in debug mode
      if (kDebugMode) {
        AppLogger.debug('Frame rendered at: $timeStamp');
      }
    });
  }
  
  /// Report critical performance issues
  static void reportPerformanceIssue(String issue, {Map<String, dynamic>? metadata}) {
    AppLogger.critical('Performance issue: $issue', error: metadata);
    
    // In production, this would be sent to a monitoring service
    if (AppConfig.isProduction) {
      _sendToMonitoringService(issue, metadata);
    }
  }
  
  /// Send performance data to monitoring service (placeholder)
  static void _sendToMonitoringService(String issue, Map<String, dynamic>? metadata) {
    // TODO: Integrate with Firebase Performance Monitoring or similar service
    AppLogger.info('Would send to monitoring service: $issue');
  }
  
  /// Track custom metrics
  static void trackCustomMetric(String name, double value, {String? unit}) {
    AppLogger.info('Custom metric - $name: $value${unit != null ? ' $unit' : ''}');
    
    // TODO: Send to analytics service
    if (AppConfig.enableAnalytics) {
      _sendCustomMetric(name, value, unit);
    }
  }
  
  /// Send custom metric to analytics
  static void _sendCustomMetric(String name, double value, String? unit) {
    // TODO: Integrate with Firebase Analytics or similar
    AppLogger.debug('Custom metric sent: $name = $value $unit');
  }
}

/// Extension for easy performance monitoring
extension PerformanceMonitorExtension<T> on Future<T> {
  /// Monitor this Future's performance
  Future<T> monitor(String operation) {
    return PerformanceMonitor.monitorAsync(operation, () => this);
  }
}

/// Widget for monitoring build performance
class PerformanceMonitorWidget extends StatefulWidget {
  final Widget child;
  final String name;
  
  const PerformanceMonitorWidget({
    super.key,
    required this.child,
    required this.name,
  });
  
  @override
  State<PerformanceMonitorWidget> createState() => _PerformanceMonitorWidgetState();
}

class _PerformanceMonitorWidgetState extends State<PerformanceMonitorWidget> {
  @override
  void initState() {
    super.initState();
    if (AppConfig.enableVerboseLogging) {
      PerformanceMonitor.startTimer('widget_build_${widget.name}');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
  
  @override
  void dispose() {
    if (AppConfig.enableVerboseLogging) {
      PerformanceMonitor.stopTimer('widget_build_${widget.name}');
    }
    super.dispose();
  }
}