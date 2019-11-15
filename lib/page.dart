import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  }

  void navigateToAuth() {
    Navigator.popAndPushNamed(context, "/auth");
  }

  void navigateToProfile() {
    Navigator.popAndPushNamed(context, "/profile");
  }

  void navigateToSignOut() async {
    Navigator.popAndPushNamed(context, "/");
    _auth.signOut();
  }

  void navigateToInbox() {
    Navigator.pushNamed(context, "/inbox");
  }

  void navigateToNotifications() {
    Navigator.pushNamed(context, "/notifications");
  }

  void navigateToSettings() {
    if (_globalKey.currentState.isEndDrawerOpen) {
      Navigator.pop(context);
    }
    Navigator.pushNamed(context, "/settings");
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
    return WillPopScope(
      onWillPop: () async {
        if (_auth.state == AuthState.SIGNED_IN) {
          _auth.state = AuthState.SIGNED_IN;
        } else if (_auth.state == AuthState.SIGNED_OUT) {
          _auth.state = AuthState.SIGNED_OUT;
        }
        else {
          
        }
        return false;
      },
      child: _authState == AuthState.LOADING
          ? LoadingScreen()
          : SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        "assets/back.gif",
                      ),
                      fit: BoxFit.fill),
                ),
                child: Scaffold(
                  key: _globalKey,
                  floatingActionButton: widget.fab,
                  drawer: !_isLeftHanded ? buildDrawer() : null,
                  endDrawer: _isLeftHanded ? null : buildDrawer(),
                  appBar: AppBar(
                    iconTheme:
                        IconThemeData(color: Colors.white.withOpacity(.7)),
                    backgroundColor: Colors.black.withOpacity(0.5),
                    elevation: 0,
                    actions: buildActions(),
                    title: Text("G-SEC"),
                    centerTitle: true,
                  ),
                  backgroundColor: Colors.transparent,
                  body: Container(
                    decoration: BoxDecoration(
                        //color: Colors.black.withOpacity(.3),
                        ),
                    margin: EdgeInsets.only(
                        bottom: 10, right: 10, left: 10, top: 10),
                    child: widget.child,
                  ),
                ),
              ),
            ),
    );
  }

  buildActions() {
    if (_authState == AuthState.SIGNED_IN) {
      return [
        /*IconButton(
            icon: Icon(FontAwesomeIcons.globeAfrica),
            onPressed: navigateToNotifications),
        IconButton(
            icon: Icon(FontAwesomeIcons.solidEnvelope),
            onPressed: navigateToInbox),*/
        IconButton(
            icon: Icon(FontAwesomeIcons.solidUser),
            onPressed: navigateToProfile),
        _isLeftHanded
            ? IconButton(
                icon: Icon(FontAwesomeIcons.bars),
                onPressed: () {
                  _globalKey.currentState.openEndDrawer();
                },
              )
            : Container()
      ];
    } else {
      return [
        _isLeftHanded
            ? IconButton(
                icon: Icon(FontAwesomeIcons.bars),
                onPressed: () {
                  _globalKey.currentState.openEndDrawer();
                },
              )
            : Container()
      ];
    }
  }

  buildDrawer() {
    return Container(
      color: Colors.black.withOpacity(0.9),
      width: 250,
      child: Column(
        children: <Widget>[
          if (_auth.state == AuthState.SIGNED_IN)
            buildDrawerTile(
              "Sign out",
              FontAwesomeIcons.signOutAlt,
              navigateToSignOut,
            )
          else
            buildDrawerTile(
              "SignIn/Register",
              FontAwesomeIcons.signInAlt,
              navigateToAuth,
            ),
          buildDrawerTile(
            "Settings",
            FontAwesomeIcons.cog,
            navigateToSettings,
          ),
          buildDrawerTile(
            "share",
            FontAwesomeIcons.shareAlt,
            navigateToAuth,
          )
        ],
      ),
    );
  }

  Column buildDrawerTile(
      String label, IconData iconData, VoidCallback callback) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(
            label,
            style: TextStyle(color: Colors.white),
          ),
          onTap: callback,
          trailing: Icon(
            iconData,
            color: Colors.white,
          ),
        ),
        Divider(
          color: Colors.white,
        )
      ],
    );
  }
}
