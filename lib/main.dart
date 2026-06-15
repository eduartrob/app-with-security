import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:protection_information/core/l10n/app_localizations.dart';

import 'features/auth/login/data/datasource/login_datasource.dart';
import 'features/splash/presentation/pages/splash_page.dart';
import 'features/security/presentation/pages/fake_gps_page.dart';
import 'features/security/presentation/pages/usb_debugging_page.dart';
import 'features/auth/login/presentation/provider/login_provider.dart';
import 'features/auth/register/data/datasource/register_datasource.dart';
import 'features/auth/register/presentation/provider/register_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';

import 'core/services/location_service.dart';
import 'core/services/security_service.dart';
import 'core/services/storage_service.dart';
import 'core/services/session_service.dart';
import 'core/services/secure_data_service.dart';
import 'core/services/notification_history_service.dart';
import 'core/services/user_profile_service.dart';
import 'features/auth/login/presentation/pages/login_page.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase already initialized or missing options');
  }

  debugPrint("🚨 FCM Background Message ID: ${message.messageId}");

  if (message.data['action'] == 'remote_wipe') {
    final secureDataService = SecureDataService();
    await secureDataService.wipeSensitiveData();

    // Guardar en el historial aunque la app esté cerrada
    final historyService = NotificationHistoryService();
    await historyService.loadHistory();
    await historyService.addNotification(
      title: '🚨 Seguridad: Borrado Remoto',
      body: 'Se ha ejecutado un borrado remoto de la bóveda de datos por seguridad.',
      type: 'remote_wipe',
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    
    // Request permission for iOS/Web
    await FirebaseMessaging.instance.requestPermission();
  } catch (e) {
    debugPrint('Firebase Initialization Error: $e');
  }

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
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

bool isAppBlockedByFakeGps = false;
bool isAppBlockedByUsbDebugging = false;

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    _setupForegroundMessaging();
  }

  void _setupForegroundMessaging() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint("🚨 FCM Foreground Message: ${message.messageId}");
      
      final currentContext = navigatorKey.currentContext;
      
      // 1. Mostrar mensaje dentro de la app (SnackBar)
      // Solo mostramos este si NO es remote_wipe, porque remote_wipe tiene el suyo rojo abajo
      if (message.data['action'] != 'remote_wipe') {
        scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(
            content: Text(message.notification?.title ?? 'Nueva Notificación'),
            duration: const Duration(seconds: 4),
            backgroundColor: const Color(0xFF4C6455), // Verde oscuro de la app
            behavior: SnackBarBehavior.floating,
          ),
        );
      }

      // 2. Guardar en el historial
      if (currentContext != null) {
        currentContext.read<NotificationHistoryService>().addNotification(
          title: message.notification?.title ?? 'Notificación',
          body: message.notification?.body ?? 'Contenido de la notificación.',
          type: message.data['action'],
        );
      }

      // 3. Evaluar lógica de Borrado Remoto
      if (message.data['action'] == 'remote_wipe') {
        if (currentContext != null) {
          final secureDataService = currentContext.read<SecureDataService>();
          await secureDataService.wipeSensitiveData();
          
          scaffoldMessengerKey.currentState?.showSnackBar(
            const SnackBar(
              content: Text('Tus datos sensibles han sido borrados remotamente por seguridad.'),
              duration: Duration(seconds: 5),
              backgroundColor: Colors.redAccent,
            ),
          );
        } else {
          // Fallback if context is not available
          await SecureDataService().wipeSensitiveData();
        }
      }
    });
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
      _checkUsbDebuggingRealTime();
      
      // Checar si la sesión expiró mientras la app estaba en segundo plano
      final currentContext = navigatorKey.currentContext;
      if (currentContext != null) {
        currentContext.read<SessionService>().checkBackgroundTimeout();
      }
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

  Future<void> _checkUsbDebuggingRealTime() async {
    final currentContext = navigatorKey.currentContext;
    if (currentContext == null) return;
    
    final securityService = currentContext.read<SecurityService>();
    final isUsbDebugging = await securityService.isUsbDebuggingEnabled();
    
    // Si la depuración está activa (y asumiendo que el usuario remueva !kDebugMode para probar, 
    // o estemos en producción), bloqueamos
    if (isUsbDebugging) {
      if (!isAppBlockedByUsbDebugging) {
        isAppBlockedByUsbDebugging = true;
        navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const UsbDebuggingPage()),
          (route) => false,
        );
      }
    } else {
      if (isAppBlockedByUsbDebugging) {
        isAppBlockedByUsbDebugging = false;
        // Si ya se quitó el USB Debugging, reiniciamos el flujo
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
        ChangeNotifierProvider(
          create: (context) {
            final service = UserProfileService(context.read<StorageService>());
            service.loadProfile();
            return service;
          },
        ),
        Provider<LocationService>(
          create: (_) => LocationService(),
        ),
        ChangeNotifierProvider<SecureDataService>(
          create: (_) => SecureDataService(),
        ),
        ChangeNotifierProvider<NotificationHistoryService>(
          create: (_) => NotificationHistoryService()..loadHistory(),
        ),
        ChangeNotifierProvider<SessionService>(
          create: (context) {
            final service = SessionService(context.read<StorageService>());
            service.onSessionExpired = () {
              navigatorKey.currentState?.pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
              
              final currentContext = navigatorKey.currentContext;
              
              // Obtener el idioma actual si es posible, o usar un texto predeterminado
              final l10n = currentContext != null ? AppLocalizations.of(currentContext) : null;
              final message = l10n != null 
                  ? 'Sesión cerrada por inactividad' // Hardcodeado por ahora
                  : 'Sesión cerrada por inactividad';
                  
              // Usar el scaffoldMessengerKey global para que nunca falle sin importar el contexto
              scaffoldMessengerKey.currentState?.showSnackBar(
                SnackBar(
                  content: Text(message),
                  duration: const Duration(seconds: 4),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.redAccent,
                ),
              );
            };
            return service;
          },
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
        scaffoldMessengerKey: scaffoldMessengerKey,
        debugShowCheckedModeBanner: false,
        title: 'Protection Information',
        builder: (context, child) {
          return Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: (_) => context.read<SessionService>().userInteracted(),
            onPointerMove: (_) => context.read<SessionService>().userInteracted(),
            onPointerUp: (_) => context.read<SessionService>().userInteracted(),
            child: child ?? const SizedBox.shrink(),
          );
        },
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
