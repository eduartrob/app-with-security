import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/auth/login/data/datasource/login_datasource.dart';
import 'features/auth/login/presentation/pages/login_page.dart';
import 'features/auth/login/presentation/provider/login_provider.dart';
import 'features/auth/register/data/datasource/register_datasource.dart';
import 'features/auth/register/presentation/provider/register_provider.dart';

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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
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
        debugShowCheckedModeBanner: false,
        title: 'Protection Information',
        // DevicePreview configuration (descomentar si se usa DevicePreview)
        // locale: DevicePreview.locale(context),
        // builder: DevicePreview.appBuilder,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4C6455)),
          useMaterial3: true,
          fontFamily: 'Plus Jakarta Sans',
        ),
        home: const LoginPage(),
      ),
    );
  }
}
