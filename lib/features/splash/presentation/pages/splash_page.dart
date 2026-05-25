import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/services/storage_service.dart';
import '../../../auth/login/presentation/pages/login_page.dart';
import '../../../home/presentation/pages/home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    // Breve pausa para mostrar el logo/animación
    await Future.delayed(const Duration(milliseconds: 1000));
    
    if (!mounted) return;
    final storageService = context.read<StorageService>();
    final isLoggedIn = await storageService.getString('is_logged_in');

    if (!mounted) return;
    if (isLoggedIn == 'true') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: Color(0xFFEEEEED),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.spa,
                  color: Color(0xFF4C6455),
                  size: 40,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(
              color: Color(0xFF4C6455),
            ),
          ],
        ),
      ),
    );
  }
}
