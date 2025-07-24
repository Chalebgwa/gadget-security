import 'package:flutter/material.dart';
import 'package:gsec/providers/auth_provider.dart';
import 'package:gsec/views/dashboard.dart';
import 'package:gsec/views/loading_screen.dart';
import 'package:provider/provider.dart';

import 'fancy_drawer.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  Auth? _auth;

  @override
  void initState() {
    super.initState();
    // Auth will be available through Provider context
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _auth = Provider.of<Auth>(context);
  }

  @override
  Widget build(BuildContext context) {
    if (_auth == null) {
      return const LoadingScreen();
    }

    Widget screen;

    switch (_auth!.state) {
      case AuthState.signedOut:
        screen = const FancyDrawer();
        break;
      case AuthState.loading:
      case AuthState.safeLoading:
        screen = const LoadingScreen();
        break;
      case AuthState.signedIn:
        screen = const FancyDrawer();
        break;
      default:
        screen = const FancyDrawer();
    }

    return screen;
  }
}
