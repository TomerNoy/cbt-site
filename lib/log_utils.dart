import 'dart:developer';

import 'package:flutter/foundation.dart';

// Function to get the current timestamp
String _getCurrentTime() {
  final now = DateTime.now();
  return '${now.hour.toString().padLeft(2, '0')}:'
      '${now.minute.toString().padLeft(2, '0')}:'
      '${now.second.toString().padLeft(2, '0')}';
}

// Log a debug message
void logDebug(String message) {
  if (kDebugMode) {
    final time = _getCurrentTime();
    log('DEBUG [$time]: $message', level: 900);
  }
}

// Log a warning message
void logWarning(String message) {
  if (kDebugMode) {
    final time = _getCurrentTime();
    log('WARNING [$time]: $message', level: 900); // 900 indicates a warning level
  }
}

// Log an error message
void logError(String message) {
  if (kDebugMode) {
    final time = _getCurrentTime();
    log('ERROR [$time]: $message', level: 1000); // 1000 indicates an error level
  }
}

