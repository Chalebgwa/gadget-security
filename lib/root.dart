import 'package:flutter/material.dart';
import 'package:gsec/providers/auth_provider.dart';
import 'package:gsec/views/dashboard.dart';
import 'package:gsec/views/loading_screen.dart';
import 'package:provider/provider.dart';

import 'fancy_drawer.dart';

class Root extends StatefulWidget {
  Root({Key key}) : super(key: key);

  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  Auth _auth;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _auth = Provider.of<Auth>(context);
  }

  @override
  Widget build(BuildContext context) {
    switch (_auth.state) {
      case AuthState.SIGNED_OUT:
        return FancyDrawer();
      case AuthState.LOADING:
        return LoadingScreen();
      case AuthState.SIGNED_IN:
        return FancyDrawer();
      default:
        return FancyDrawer();
    }
  }
}
