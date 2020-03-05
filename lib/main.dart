import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gsec/fancy_theme.dart';
import 'package:gsec/models/notifications.dart';
import 'package:gsec/providers/auth_provider.dart';
import 'package:gsec/providers/chat_provider.dart';
import 'package:gsec/providers/device_provider.dart';
import 'package:gsec/providers/notifications_provider.dart';
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
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Streams are created so that app can respond to notification-related events since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var initializationSettingsAndroid = AndroidInitializationSettings(
    '@drawable/splash',
  );

  var initializationSettingsIOS = IOSInitializationSettings(
    requestAlertPermission: false,
    requestBadgePermission: false,
    requestSoundPermission: false,
    onDidReceiveLocalNotification:
        (int id, String title, String body, String payload) async {
      didReceiveLocalNotificationSubject.add(
        ReceivedNotification(
          id: id,
          title: title,
          body: body,
          payload: payload,
        ),
      );
    },
  );
  var initializationSettings = InitializationSettings(
    initializationSettingsAndroid,
    initializationSettingsIOS,
  );
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onSelectNotification: (String payload) async {
      if (payload != null) {
        debugPrint('notification payload: ' + payload);
      }
      selectNotificationSubject.add(payload);
    },
  );

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
      key: Key("root_provider"),
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) {
            var notificationProvider = NotificationProvider();
            notificationProvider.init();
            notificationProvider.showNotificationWithDefaultSound();
            return notificationProvider;
          },
        ),
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
  NotificationProvider _notificationProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    isDarkThemed = Provider.of<SettingsProvider>(context).isDarkTheme;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      checkerboardRasterCacheImages: true,
      showPerformanceOverlay: true,
      debugShowCheckedModeBanner: false,
      //    theme: isDarkThemed ? fancyDarkTheme : fancyLightTheme,
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
