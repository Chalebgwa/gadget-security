import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gsec/fancy_theme.dart';
import 'package:gsec/providers/auth_provider.dart';
import 'package:gsec/providers/chat_provider.dart';
import 'package:gsec/providers/device_provider.dart';
import 'package:gsec/providers/payment_service.dart';
import 'package:gsec/providers/settings_provider.dart';
import 'package:gsec/root.dart';
import 'package:gsec/views/authentication/authentication.dart';
import 'package:gsec/views/chat/chat.dart';
import 'package:gsec/views/commerce/donate.dart';
import 'package:gsec/views/dashboard.dart';
import 'package:gsec/views/notifications.dart';
import 'package:gsec/views/profile/add_device.dart';
import 'package:gsec/views/profile/edit_profile.dart';
import 'package:gsec/views/profile/profile.dart';
import 'package:gsec/views/settings.dart';
import 'package:gsec/views/util/scanner.dart';
import "package:provider/provider.dart";

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      child: App(),
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) => PayService(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => Auth(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => DeviceProvider(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => SettingsProvider(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => ChatProvider(),
        ),
      ],
    );
  }
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  bool isDarkThemed = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    isDarkThemed = Provider.of<SettingsProvider>(context).isDarkTheme;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: isDarkThemed ? fancyDarkTheme : fancyLightTheme,
      title: 'Gadget Security',
      initialRoute: "/",
      routes: {
        "/": (context) => Root(),
        "/auth": (context) => Athentication(),
        "/scanner": (context) => ScanScreen(),
        "/donate": (context) => Donate(),
        "/profile": (context) => Profile(),
        "/editProfile": (context) => EditProfile(),
        "/addDevice": (context) => AddDevice(),
        "/inbox": (context) => Inbox(),
        "/notifications": (context) => Notifications(),
        "/settings": (context) => Settings(),
        "/dashboard": (context) => Dashboard()
      },
    );
  }
}

class AllowMultipleGestureRecognizer extends TapGestureRecognizer {
  @override
  void rejectGesture(int pointer) {
    acceptGesture(pointer);
  }
}
