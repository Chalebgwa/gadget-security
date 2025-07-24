import 'package:flutter/material.dart';
import 'package:gsec/pages/dashboard.dart';
import 'package:gsec/provider/payments.dart';
import 'package:gsec/provider/security.dart';
import 'package:gsec/providers/auth_provider.dart';
import 'package:gsec/providers/device_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:gsec/config/app_config.dart';
import 'package:gsec/pages/dashboard.dart';
import 'package:gsec/provider/payments.dart';
import 'package:gsec/provider/security.dart';
import 'package:gsec/providers/auth_provider.dart';
import 'package:gsec/providers/device_provider.dart';
import 'package:gsec/utils/app_logger.dart';
import 'package:gsec/widgets/error_handler.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize global error handling
  GlobalErrorHandler.initialize();
  
  try {
    // Initialize Firebase
    await Firebase.initializeApp();
    AppLogger.info('Firebase initialized successfully');
    
    // Log app startup
    AppLogger.logAppLifecycle('App starting');
    if (AppConfig.isDevelopment) {
      AppLogger.debug('Running in development mode');
      AppLogger.debug('Config: ${AppConfig.getConfigSummary()}');
    }
    
    runApp(const App());
  } catch (e, stackTrace) {
    AppLogger.critical('Failed to initialize app', error: e, stackTrace: stackTrace);
    // Still try to run the app with minimal functionality
    runApp(const App());
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) => Auth(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => DeviceProvider(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => Security(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => Payments(),
        ),
      ],
      child: const Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppConfig.appName,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
          brightness: Brightness.light,
        ),
        iconTheme: IconThemeData(
          color: Colors.purple.shade200,
        ),
        appBarTheme: AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.purple,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      darkTheme: AppConfig.enableDarkMode ? ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
          brightness: Brightness.dark,
        ),
        appBarTheme: AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.purple.shade800,
          foregroundColor: Colors.white,
        ),
      ) : null,
      themeMode: AppConfig.enableDarkMode ? ThemeMode.system : ThemeMode.light,
      home: Consumer<Auth>(
        builder: (context, auth, child) {
          // Show appropriate screen based on auth state
          switch (auth.state) {
            case AuthState.loading:
            case AuthState.safeLoading:
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            case AuthState.signedIn:
              return Dashboard();
            case AuthState.signedOut:
            default:
              return Dashboard(); // Dashboard will show sign-in option
          }
        },
      ),
    );
  }
}
