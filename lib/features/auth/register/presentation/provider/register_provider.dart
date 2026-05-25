import 'package:flutter/material.dart';
import '../../data/datasource/register_datasource.dart';

class RegisterProvider extends ChangeNotifier {
  final RegisterDataSource _dataSource;

  RegisterProvider(this._dataSource);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isSuccess = false;
  bool get isSuccess => _isSuccess;

  Future<void> register(String fullName, String email, String password) async {
    if (fullName.isEmpty || email.isEmpty || password.isEmpty) {
      _errorMessage = 'errorEmptyFields';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    _isSuccess = false;
    notifyListeners();

    try {
      final success = await _dataSource.register(fullName, email, password);
      
      if (success) {
        _isSuccess = true;
        _errorMessage = null;
      } else {
        _isSuccess = false;
        _errorMessage = 'errorInvalidCredentials';
      }
    } catch (e) {
      _isSuccess = false;
      _errorMessage = 'errorInvalidCredentials';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void resetState() {
    _isLoading = false;
    _errorMessage = null;
    _isSuccess = false;
    notifyListeners();
  }
}
