import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'providers/theme_provider.dart';
import 'providers/auth_provider.dart';
import 'utils/app_theme.dart';
import 'app/routes.dart';

Future<void> main() async {
  // 1. Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // 2. iOS BADGE PERMISSION and Notifications Initialization
  final notifications = FlutterLocalNotificationsPlugin();
  const iosSettings = DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true, // Crucial for showing notification badge count
    requestSoundPermission: false,
  );

  const settings = InitializationSettings(iOS: iosSettings);
  await notifications.initialize(settings);

  // 3. Run the app with MultiProvider
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const MemesflixxApp(),
    ),
  );
}

class MemesflixxApp extends StatelessWidget {
  const MemesflixxApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Memesflixx',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      initialRoute: '/splash',
      routes: appRoutes,
    );
  }
}
