import 'package:flutter/material.dart';
import 'package:gsec/providers/auth_provider.dart';
import 'package:gsec/views/loading_screen.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:provider/provider.dart';

import 'fancy_drawer.dart';

class Root extends StatefulWidget {
  Root({Key key}) : super(key: key);

  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  Auth _auth;

  final mainView = FancyDrawer();
  final loadingScreen = LoadingScreen();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _auth = Provider.of<Auth>(context);
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    
    if (_auth.state == AuthState.LOADING) {
      return loadingScreen;
    } else {
      return mainView;
    }
  }
}
