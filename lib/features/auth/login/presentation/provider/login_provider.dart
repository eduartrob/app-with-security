import 'package:flutter/material.dart';
import '../../data/datasource/login_datasource.dart';

class LoginProvider extends ChangeNotifier {
  final LoginDataSource _dataSource;

  LoginProvider(this._dataSource);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isSuccess = false;
  bool get isSuccess => _isSuccess;

  Future<void> login(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      _errorMessage = 'Por favor, ingrese sus credenciales.';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    _isSuccess = false;
    notifyListeners();

    try {
      final success = await _dataSource.login(username, password);
      
      if (success) {
        _isSuccess = true;
        _errorMessage = null;
      } else {
        _isSuccess = false;
        _errorMessage = 'Credenciales incorrectas.';
      }
    } catch (e) {
      _isSuccess = false;
      _errorMessage = 'Error de conexión. Inténtelo de nuevo.';
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
