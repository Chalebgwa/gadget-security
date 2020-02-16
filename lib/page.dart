import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gsec/providers/auth_provider.dart';
import 'package:gsec/providers/settings_provider.dart';
import 'package:gsec/views/loading_screen.dart';
import 'package:provider/provider.dart';

// wraps every screen in the app
class Page extends StatefulWidget {
  Page({Key key, this.child, this.fab}) : super(key: key);

  final Widget child;

  final FloatingActionButton fab;

  _PageState createState() => _PageState();
}

class _PageState extends State<Page> {
  Auth _auth;
  AuthState _authState = AuthState.SIGNED_OUT;
  final GlobalKey<ScaffoldState> _globalKey = new GlobalKey<ScaffoldState>();
  SettingsProvider _settingsProvider;
  bool _isLeftHanded = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _auth = Provider.of<Auth>(context);
    _authState = _auth.state;
    _settingsProvider = Provider.of<SettingsProvider>(context);
    _isLeftHanded = _settingsProvider.isLeftHanded;
  }

  @override
  Widget build(BuildContext context) {
    return _authState == AuthState.SAFE_LOADING
        ? Center(
            child: LoadingScreen(),
          )
        : SafeArea(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    "assets/back3.jpg",
                  ),
                  fit: BoxFit.fill,
                ),
              ),
              child: Scaffold(
                key: _globalKey,
                floatingActionButton: widget.fab,
                backgroundColor: Colors.transparent,
                resizeToAvoidBottomInset: true,
                body: Container(
                  decoration: BoxDecoration(
                      //color: Colors.black.withOpacity(.3),
                      ),
                  margin:
                      EdgeInsets.only(bottom: 10, right: 10, left: 10, top: 10),
                  child: widget.child,
                ),
              ),
            ),
          );
  }
}
