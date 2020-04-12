import 'package:flutter/material.dart';
import 'package:gsec/pages/dashboard.dart';
import 'package:gsec/pages/page.dart';
import 'package:gsec/provider/payments.dart';
import 'package:gsec/provider/security.dart';
import 'package:gsec/widgets/neumorphs.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  const App({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) => Security(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => Payments(),
        ),
      ],
      child: Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
        accentColor: Colors.grey,
        iconTheme: IconThemeData(
          color: Colors.purple[200]
        )
      ),
      home: Dashboard(),
    );
  }
}
