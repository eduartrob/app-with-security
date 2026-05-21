class RegisterDataSource {
  Future<bool> register(String fullName, String email, String password) async {
    // Simular latencia de red
    await Future.delayed(const Duration(seconds: 2));

    // Lógica básica de validación simulada
    if (fullName.isNotEmpty && email.contains('@') && password.length >= 4) {
      return true;
    }
    return false;
  }
}
