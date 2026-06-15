import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureDataService extends ChangeNotifier {
  final _secureStorage = const FlutterSecureStorage();
  
  static const String _keyBank = 'bank_account';
  static const String _keyPin = 'credit_card_pin';
  static const String _keyCrypto = 'crypto_wallet_key';
  static const String _keyMedical = 'medical_record_id';

  Map<String, String?> _currentData = {};

  Map<String, String?> get currentData => _currentData;
  bool _isWiped = false; // Bandera en memoria para evitar regenerarlos

  Future<void> saveData({
    required String bankAccount,
    required String pin,
    required String cryptoKey,
    required String medicalId,
  }) async {
    await _secureStorage.write(key: _keyBank, value: bankAccount);
    await _secureStorage.write(key: _keyPin, value: pin);
    await _secureStorage.write(key: _keyCrypto, value: cryptoKey);
    await _secureStorage.write(key: _keyMedical, value: medicalId);
    
    // Al guardar exitosamente, lo marcamos como NO borrado
    _isWiped = false;
    await loadData();
  }

  Future<void> loadData() async {
    _currentData = {
      'Cuenta Bancaria': await _secureStorage.read(key: _keyBank),
      'PIN de Tarjeta': await _secureStorage.read(key: _keyPin),
      'Llave Crypto': await _secureStorage.read(key: _keyCrypto),
      'ID Historial Médico': await _secureStorage.read(key: _keyMedical),
    };
    notifyListeners();
  }

  Future<void> wipeSensitiveData() async {
    debugPrint('EJECUTANDO BORRADO REMOTO DE DATOS SENSIBLES');
    _isWiped = true;
    await _secureStorage.delete(key: _keyBank);
    await _secureStorage.delete(key: _keyPin);
    await _secureStorage.delete(key: _keyCrypto);
    await _secureStorage.delete(key: _keyMedical);
    await loadData();
    debugPrint('DATOS ELIMINADOS CON ÉXITO');
  }
}
