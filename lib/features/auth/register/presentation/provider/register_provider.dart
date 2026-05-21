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
      _errorMessage = 'Por favor, llene todos los campos.';
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
        _errorMessage = 'Datos inválidos. Inténtalo de nuevo.';
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
