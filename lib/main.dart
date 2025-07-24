import 'package:flutter/material.dart';
import 'package:gsec/pages/dashboard.dart';
import 'package:gsec/provider/payments.dart';
import 'package:gsec/provider/security.dart';
import 'package:gsec/providers/auth_provider.dart';
import 'package:gsec/providers/device_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const App());
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
      title: 'Gadget Security',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
          brightness: Brightness.light,
        ),
        iconTheme: IconThemeData(
          color: Colors.purple.shade200,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.system,
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
