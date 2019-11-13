import 'package:flutter/material.dart';
import 'package:gsec/providers/auth_provider.dart';
import 'package:gsec/providers/chat_provider.dart';
import 'package:gsec/providers/device_provider.dart';
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

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {    
    return MultiProvider(
      child: MaterialApp(
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
          "/dashboard":(context) => Dashboard()
        },
      ),
      providers: <SingleChildCloneableWidget>[
        ChangeNotifierProvider(
          builder: (BuildContext context) => Auth(),
        ),
        ChangeNotifierProvider(
          builder: (BuildContext context) => DeviceProvider(),
        ),
        ChangeNotifierProvider(
          builder: (BuildContext context) => SettingsProvider(),
        ),
        ChangeNotifierProvider(
          builder: (BuildContext context) => ChatProvider(),
        ),
      ],
    );
  }
}
