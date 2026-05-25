import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/services/security_service.dart';

import '../provider/register_provider.dart';
import '../../../login/presentation/widgets/custom_text_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with SingleTickerProviderStateMixin {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  late SecurityService _securityService;

  @override
  void initState() {
    super.initState();

    // Animaciones de entrada
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _securityService = context.read<SecurityService>();
    _securityService.preventScreenshots(true);
  }

  @override
  void dispose() {
    _securityService.preventScreenshots(false);
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color bgBackground = Color(0xFFF9F9F9);
    const Color textPrimary = Color(0xFF4C6455);
    const Color textSecondary = Color(0xFF5F5E58);
    const Color surfaceContainer = Color(0xFFEEEEED);
    const Color onSurface = Color(0xFF1A1C1C);
    const Color primaryColor = Color(0xFF4C6455);
    const Color onPrimary = Color(0xFFFFFFFF);
    const Color outlineVariant = Color(0xFFC2C8C2);

    return Scaffold(
      backgroundColor: bgBackground,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Titulo
                    const Text(
                      'Create Account',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 40,
                        fontWeight: FontWeight.w600,
                        color: textPrimary,
                        letterSpacing: -0.8,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Subtitulo
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Begin your journey with a seamless and quiet experience.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 16,
                          color: textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Campos de texto
                    CustomTextField(
                      controller: _fullNameController,
                      hintText: 'Full Name',
                      surfaceContainer: surfaceContainer,
                      onSurface: onSurface,
                      textSecondary: textSecondary,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _emailController,
                      hintText: 'Email Address',
                      surfaceContainer: surfaceContainer,
                      onSurface: onSurface,
                      textSecondary: textSecondary,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _passwordController,
                      hintText: 'Password',
                      obscureText: true,
                      surfaceContainer: surfaceContainer,
                      onSurface: onSurface,
                      textSecondary: textSecondary,
                    ),
                    
                    // Mensaje de Error (Selector optimizado)
                    Selector<RegisterProvider, String?>(
                      selector: (_, provider) => provider.errorMessage,
                      builder: (context, errorMessage, _) {
                        return errorMessage != null
                            ? Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: AnimatedOpacity(
                                  opacity: 1.0,
                                  duration: const Duration(milliseconds: 300),
                                  child: Text(
                                    errorMessage,
                                    style: const TextStyle(color: Colors.redAccent, fontSize: 14),
                                  ),
                                ),
                              )
                            : const SizedBox.shrink();
                      },
                    ),

                    // Boton Primario (Animado y con RepaintBoundary)
                    const SizedBox(height: 24),
                    Selector<RegisterProvider, bool>(
                      selector: (_, provider) => provider.isLoading,
                      builder: (context, isLoading, _) {
                        return RepaintBoundary(
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: double.infinity,
                            height: 56,
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(28),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(28),
                                onTap: isLoading
                                    ? null
                                    : () {
                                        FocusScope.of(context).unfocus();
                                        final provider = context.read<RegisterProvider>();
                                        provider.register(
                                          _fullNameController.text.trim(),
                                          _emailController.text.trim(),
                                          _passwordController.text.trim(),
                                        ).then((_) {
                                          if (provider.isSuccess && mounted) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text('¡Cuenta Creada!')),
                                            );
                                            // Redirigir al login (ya estamos en Register que fue pusheada desde Login, así que pop())
                                            Navigator.pop(context);
                                          }
                                        });
                                      },
                                child: Center(
                                  child: isLoading
                                      ? const SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: CircularProgressIndicator(
                                            color: onPrimary,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              'Create Account',
                                              style: TextStyle(
                                                fontFamily: 'Plus Jakarta Sans',
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: onPrimary,
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            Icon(Icons.arrow_forward, color: onPrimary, size: 20),
                                          ],
                                        ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    // Or continue with...
                    const SizedBox(height: 48),
                    Row(
                      children: [
                        Expanded(child: Container(height: 1, color: outlineVariant)),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'OR CONTINUE WITH',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF727973), // outline
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                        Expanded(child: Container(height: 1, color: outlineVariant)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // Social Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildSocialButton(Icons.g_mobiledata, Colors.red, surfaceContainer),
                        const SizedBox(width: 16),
                        _buildSocialButton(Icons.apple, onSurface, surfaceContainer),
                      ],
                    ),

                    const SizedBox(height: 48),

                    // Footer Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an account? ',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 16,
                            color: textSecondary,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context); // Vuelve al login
                          },
                          child: const Text(
                            'Log in',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: primaryColor,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, Color iconColor, Color bgColor) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: () {},
          child: Center(
            child: Icon(icon, color: iconColor, size: 32),
          ),
        ),
      ),
    );
  }
}
