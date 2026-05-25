import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:protection_information/l10n/app_localizations.dart';

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

bool isAppBlockedByFakeGps = false;

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
      if (!isAppBlockedByFakeGps) {
        isAppBlockedByFakeGps = true;
        navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const FakeGpsPage()),
          (route) => false,
        );
      }
    } else {
      if (isAppBlockedByFakeGps) {
        isAppBlockedByFakeGps = false;
        // Si ya se quitó el Fake GPS, reiniciamos el flujo para que Splash decida a dónde ir
        navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const SplashPage()),
          (route) => false,
        );
      }
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
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''),
          Locale('es', ''),
        ],
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
