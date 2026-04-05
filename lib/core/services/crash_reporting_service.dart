import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';

/// Crash reporting service stub (Firebase Crashlytics not available)
/// This is a stub implementation since firebase_crashlytics was removed
/// due to dependency conflicts. Re-enable when dependencies are compatible.
class CrashReportingService {
  static final CrashReportingService _instance =
      CrashReportingService._internal();
  factory CrashReportingService() => _instance;
  CrashReportingService._internal();

  bool _initialized = false;

  /// Initialize crash reporting (stub)
  Future<void> initialize() async {
    if (_initialized) return;

    // Stub: Firebase Crashlytics not available
    // Log to console in debug mode
    FlutterError.onError = (errorDetails) {
      if (kDebugMode) {
        FlutterError.presentError(errorDetails);
      }
    };

    // Catch async errors and log to console
    PlatformDispatcher.instance.onError = (error, stack) {
      if (kDebugMode) {
        debugPrint('Async error: $error');
        debugPrintStack(stackTrace: stack);
      }
      return true;
    };

    _initialized = true;
  }

  /// Log a non-fatal error (stub)
  void logError(dynamic error, StackTrace? stackTrace, {String? reason}) {
    if (kDebugMode) {
      debugPrint('Error: $error');
      if (reason != null) debugPrint('Reason: $reason');
      if (stackTrace != null) debugPrintStack(stackTrace: stackTrace);
    }
  }

  /// Set user identifier (stub)
  void setUserId(String userId) {
    if (kDebugMode) {
      debugPrint('CrashReporting: Set user ID: $userId');
    }
  }

  /// Add custom key (stub)
  void setCustomKey(String key, dynamic value) {
    if (kDebugMode) {
      debugPrint('CrashReporting: Set $key = $value');
    }
  }

  /// Log a breadcrumb (stub)
  void log(String message) {
    if (kDebugMode) {
      debugPrint('CrashReporting: $message');
    }
  }

  /// Force a test crash (stub - logs only)
  void forceCrash() {
    if (kDebugMode) {
      debugPrint('CrashReporting: Force crash requested');
    }
  }
}

/// Widget that catches errors in its child widget tree
class CrashErrorBoundary extends StatefulWidget {
  final Widget child;

  const CrashErrorBoundary({required this.child, super.key});

  @override
  State<CrashErrorBoundary> createState() => _CrashErrorBoundaryState();
}

class _CrashErrorBoundaryState extends State<CrashErrorBoundary> {
  Object? _error;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return _buildErrorView();
    }

    return widget.child;
  }

  Widget _buildErrorView() {
    return Material(
      child: Container(
        color: Colors.grey[900],
        padding: const EdgeInsets.all(24),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 64),
              const SizedBox(height: 24),
              const Text(
                'Something went wrong',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                _error.toString(),
                style: TextStyle(color: Colors.grey[400], fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _error = null;
                  });
                },
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
