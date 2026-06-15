import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'storage_service.dart';

class UserProfileService extends ChangeNotifier {
  final StorageService _storageService;
  
  String _userName = 'Usuario';
  String? _profileImageBase64;
  
  UserProfileService(this._storageService);

  String get userName => _userName;
  String? get profileImageBase64 => _profileImageBase64;

  Future<void> loadProfile() async {
    final name = await _storageService.getString('user_name');
    if (name != null && name.isNotEmpty) {
      _userName = name;
    }
    _profileImageBase64 = await _storageService.getString('profile_image_base64');
    notifyListeners();
  }

  Future<void> saveProfile({required String name, String? imageBase64}) async {
    _userName = name.isNotEmpty ? name : 'Usuario';
    await _storageService.setString('user_name', _userName);
    
    if (imageBase64 != null) {
      _profileImageBase64 = imageBase64;
      await _storageService.setString('profile_image_base64', imageBase64);
    }
    
    notifyListeners();
  }
}
