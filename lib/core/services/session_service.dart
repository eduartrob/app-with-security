import 'dart:async';
import 'package:flutter/material.dart';
import 'storage_service.dart';

class SessionService extends ChangeNotifier {
  Timer? _timer;
  final StorageService _storageService;
  final int _timeoutSeconds = 30;
  DateTime? _lastActivityTime;

  VoidCallback? onSessionExpired;

  SessionService(this._storageService);

  void startSession() {
    _lastActivityTime = DateTime.now();
    _startTimer();
  }

  void userInteracted() {
    if (_lastActivityTime != null) {
      _lastActivityTime = DateTime.now();
      _startTimer();
    }
  }

  void stopSession() {
    _timer?.cancel();
    _timer = null;
    _lastActivityTime = null;
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_lastActivityTime != null) {
        final elapsed = DateTime.now().difference(_lastActivityTime!).inSeconds;
        if (elapsed >= _timeoutSeconds) {
          _logout();
        }
      }
    });
  }

  void checkBackgroundTimeout() {
    if (_lastActivityTime != null) {
      final elapsed = DateTime.now().difference(_lastActivityTime!).inSeconds;
      if (elapsed >= _timeoutSeconds) {
        _logout();
      } else {
        _startTimer();
      }
    }
  }

  Future<void> _logout() async {
    stopSession();
    await _storageService.remove('is_logged_in');
    
    if (onSessionExpired != null) {
      onSessionExpired!();
    }
    
    notifyListeners();
  }
}
