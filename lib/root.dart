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
  void initState() {
    // TODO: implement initState
    super.initState();
    //_auth.checkLoginStatus();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _auth = Provider.of<Auth>(context);
  }

  @override
  Widget build(BuildContext context) {
    var screen;

    

    setState(() {
      
    });

    switch (_auth.state) {
      case AuthState.SIGNED_OUT:
        screen = FancyDrawer();
        break;
      case AuthState.LOADING:
        screen = LoadingScreen();
        break;
      case AuthState.SIGNED_IN:
        screen = FancyDrawer();
        break;
      default:
        return FancyDrawer();
    }

    return screen;
  }
}
