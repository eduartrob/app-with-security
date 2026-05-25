import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/auth/login/data/datasource/login_datasource.dart';
import 'features/splash/presentation/pages/splash_page.dart';
import 'features/security/presentation/pages/fake_gps_page.dart';
import 'features/auth/login/presentation/provider/login_provider.dart';
import 'features/auth/register/data/datasource/register_datasource.dart';
import 'features/auth/register/presentation/provider/register_provider.dart';
import 'core/services/location_service.dart';
import 'core/services/security_service.dart';
import 'core/services/storage_service.dart';

void main() {
  runApp(const MyApp());
  /* 
  // Descomentar para usar DevicePreview
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const MyApp(), // Wrap your app
    ),
  );
  */
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkFakeGpsRealTime();
    }
  }

  Future<void> _checkFakeGpsRealTime() async {
    final currentContext = navigatorKey.currentContext;
    if (currentContext == null) return;
    
    final locationService = currentContext.read<LocationService>();
    final isFake = await locationService.isFakeGpsActive();
    
    if (isFake) {
      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const FakeGpsPage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<SecurityService>(
          create: (_) => SecurityService(),
        ),
        Provider<StorageService>(
          create: (_) => StorageService(),
        ),
        Provider<LocationService>(
          create: (_) => LocationService(),
        ),
        Provider<LoginDataSource>(
          create: (_) => LoginDataSource(),
        ),
        ChangeNotifierProvider<LoginProvider>(
          create: (context) => LoginProvider(context.read<LoginDataSource>()),
        ),
        Provider<RegisterDataSource>(
          create: (_) => RegisterDataSource(),
        ),
        ChangeNotifierProvider<RegisterProvider>(
          create: (context) => RegisterProvider(context.read<RegisterDataSource>()),
        ),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Protection Information',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4C6455)),
          useMaterial3: true,
          fontFamily: 'Plus Jakarta Sans',
        ),
        home: const SplashPage(),
      ),
    );
  }
}
