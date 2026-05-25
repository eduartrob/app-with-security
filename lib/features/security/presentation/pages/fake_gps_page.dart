import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FakeGpsPage extends StatefulWidget {
  const FakeGpsPage({Key? key}) : super(key: key);

  @override
  State<FakeGpsPage> createState() => _FakeGpsPageState();
}

class _FakeGpsPageState extends State<FakeGpsPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
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
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color bgBackground = Color(0xFFF9F9F9);
    const Color textPrimary = Color(0xFF4C6455);
    const Color textSecondary = Color(0xFF5F5E58);
    const Color surfaceContainer = Color(0xFFEEEEED);
    const Color primaryContainer = Color(0xFF8FA998);
    const Color onPrimaryContainer = Color(0xFF273E31);
    
    // Warning colors to indicate blockage
    const Color warningColor = Color(0xFFD65B5B);
    const Color warningLight = Color(0xFFFBEAEA);

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
                    // Warning Icon
                    Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        color: warningLight,
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
                          Icons.location_off_rounded,
                          color: warningColor,
                          size: 40,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Title
                    const Text(
                      'Access Denied',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                        letterSpacing: -0.5,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Subtitle
                    const Text(
                      'Our security systems have detected the use of a Fake GPS or mock location app on your device.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 16,
                        color: textSecondary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Additional info
                    const Text(
                      'To protect the integrity of our application, you cannot continue using it while location spoofing is active.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 14,
                        color: warningColor,
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Close App Button
                    RepaintBoundary(
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
                            onTap: () {
                              if (Platform.isAndroid) {
                                SystemNavigator.pop();
                              } else if (Platform.isIOS) {
                                exit(0);
                              }
                            },
                            child: const Center(
                              child: Text(
                                'Close Application',
                                style: TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: onPrimaryContainer,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
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
