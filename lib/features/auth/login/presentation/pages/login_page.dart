import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:protection_information/l10n/app_localizations.dart';
import '../../../../../core/services/storage_service.dart';
import '../../../../../core/services/session_service.dart';
import '../../../../../core/services/security_service.dart';
import '../../../../../main.dart';
import '../provider/login_provider.dart';
import '../widgets/custom_text_field.dart';
import '../../../../home/presentation/pages/home_page.dart';
import '../../../register/presentation/pages/register_page.dart';
import '../../../../../core/services/location_service.dart';
import '../../../../security/presentation/pages/fake_gps_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  late SecurityService _securityService;

  @override
  void initState() {
    super.initState();

    // Configurar animaciones suaves de entrada
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
    // Permitir capturas nuevamente al salir de la vista sensible
    _securityService.preventScreenshots(false);
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Colores basados en el diseño HTML proporcionado
    const Color bgBackground = Color(0xFFF9F9F9);
    const Color textPrimary = Color(0xFF4C6455);
    const Color textSecondary = Color(0xFF5F5E58);
    const Color surfaceContainer = Color(0xFFEEEEED);
    const Color onSurface = Color(0xFF1A1C1C);
    const Color primaryContainer = Color(0xFF8FA998);
    const Color onPrimaryContainer = Color(0xFF273E31);
    
    final l10n = AppLocalizations.of(context)!;

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
                    // Icono Superior
                    Container(
                      width: 64,
                      height: 64,
                      decoration: const BoxDecoration(
                        color: surfaceContainer,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.spa, // Icono similar al proporcionado en material symbols
                          color: textPrimary,
                          size: 32,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Titulo
                    Text(
                      l10n.loginWelcomeBack,
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 40,
                        fontWeight: FontWeight.w600,
                        color: textPrimary,
                        letterSpacing: -0.8,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // Subtitulo
                    Text(
                      l10n.loginSubtitle,
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 16,
                        color: textSecondary,
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Campos de texto
                    CustomTextField(
                      controller: _emailController,
                      hintText: l10n.emailHint,
                      surfaceContainer: surfaceContainer,
                      onSurface: onSurface,
                      textSecondary: textSecondary,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _passwordController,
                      hintText: l10n.passwordHint,
                      obscureText: true,
                      surfaceContainer: surfaceContainer,
                      onSurface: onSurface,
                      textSecondary: textSecondary,
                    ),
                    
                    // Mensaje de Error
                    Selector<LoginProvider, String?>(
                      selector: (_, provider) => provider.errorMessage,
                      builder: (context, errorMessage, _) {
                        String? translatedError;
                        if (errorMessage == 'errorEmptyFields') {
                          translatedError = l10n.errorEmptyFields;
                        } else if (errorMessage == 'errorInvalidCredentials') {
                          translatedError = l10n.errorInvalidCredentials;
                        } else {
                          translatedError = errorMessage;
                        }

                        return translatedError != null
                            ? Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: AnimatedOpacity(
                                  opacity: 1.0,
                                  duration: const Duration(milliseconds: 300),
                                  child: Text(
                                    translatedError,
                                    style: const TextStyle(color: Colors.redAccent, fontSize: 14),
                                  ),
                                ),
                              )
                            : const SizedBox.shrink();
                      },
                    ),

                    // Boton de Login Animado
                    const SizedBox(height: 16),
                    Selector<LoginProvider, bool>(
                      selector: (_, provider) => provider.isLoading,
                      builder: (context, isLoading, _) {
                        return RepaintBoundary(
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: double.infinity,
                            height: 56,
                            decoration: BoxDecoration(
                              color: primaryContainer,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromRGBO(76, 100, 85, 0.15),
                                  blurRadius: 20,
                                  spreadRadius: -6,
                                  offset: Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: isLoading
                                    ? null
                                    : () {
                                        // Ocultar teclado
                                        FocusScope.of(context).unfocus();
                                        final provider = context.read<LoginProvider>();
                                        provider.login(
                                          _emailController.text.trim(),
                                          _passwordController.text.trim(),
                                        ).then((_) async {
                                          if (provider.isSuccess && mounted) {
                                            final locationService = context.read<LocationService>();
                                            bool isFakeGps = await locationService.isFakeGpsActive();

                                            if (!mounted) return;

                                            if (isFakeGps) {
                                              isAppBlockedByFakeGps = true;
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(builder: (context) => const FakeGpsPage()),
                                              );
                                            } else {
                                              await context.read<StorageService>().setString('is_logged_in', 'true');
                                              if (!mounted) return;
                                              context.read<SessionService>().startSession();
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text(l10n.loginSuccess)),
                                              );
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(builder: (context) => const HomePage()),
                                              );
                                            }
                                          }
                                        });
                                      },
                                child: Center(
                                  child: isLoading
                                      ? const SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: CircularProgressIndicator(
                                            color: onPrimaryContainer,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : Text(
                                          l10n.signIn,
                                          style: const TextStyle(
                                            fontFamily: 'Plus Jakarta Sans',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: onPrimaryContainer,
                                            letterSpacing: 0.7,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 48),

                    // Enlaces de pie de pagina
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        l10n.forgotPassword,
                        style: const TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      height: 1,
                      color: const Color(0xFFC2C8C2).withOpacity(0.3),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RegisterPage()),
                        );
                      },
                      child: Text(
                        l10n.signUp,
                        style: const TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: textPrimary,
                        ),
                      ),
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

}
