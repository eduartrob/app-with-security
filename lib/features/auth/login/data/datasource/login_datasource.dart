class LoginDataSource {
  Future<bool> login(String username, String password) async {
    // Simular un retraso en la red para que se vean las animaciones suaves
    await Future.delayed(const Duration(seconds: 2));

    // Validacion en duro como se solicitó (username = eduart, ok)
    if (username == 'eduart' && password == 'ok') {
      return true;
    }
    return false;
  }
}
