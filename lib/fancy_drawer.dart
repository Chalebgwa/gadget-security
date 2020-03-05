import 'dart:ui';

/**
 * 
 */

import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gsec/models/user.dart';
import 'package:gsec/page.dart';
import 'package:gsec/providers/auth_provider.dart';
import 'package:gsec/providers/settings_provider.dart';
import 'package:gsec/views/dashboard.dart';
import 'package:gsec/views/profile/profile.dart';
import 'package:gsec/views/settings.dart';
import 'package:hidden_drawer_menu/hidden_drawer/hidden_drawer_menu.dart';
import 'package:provider/provider.dart';

class FancyDrawer extends StatefulWidget {
  @override
  _FancyDrawerState createState() => _FancyDrawerState();
}

class _FancyDrawerState extends State<FancyDrawer> {
  // controller state
  Auth _auth;

  // provides to app settings
  SettingsProvider _settings;

  // Screen in focus
  Widget screen = Dashboard();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _auth = Provider.of<Auth>(context);
    _settings = Provider.of<SettingsProvider>(context);
  }

  Widget screenBuilder(index, controller) {
    var screen;

    switch (index) {
      case 0:
        screen = Dashboard();

        break;
      case 1:
        screen = Settings();

        break;
      case 2:
        screen = Profile();

        break;
      case 3:
        _auth.signOut();
        screen = Dashboard();

        break;

      default:
        screen = Dashboard();
        break;
    }

    return WillPopScope(
      onWillPop: () async {
        if (index == 0) {
          return true;
        }
        print("back pressed");

        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          actions: _buildActions(controller),
          centerTitle: true,
          title: Text(
            'Gadget Security',
            style: TextStyle(
                //color: Theme.of(context).accentColor,
                fontFamily: 'pacifico'),
          ),
          leading: IconButton(
            icon: Icon(
              FontAwesomeIcons.bars,
            ),
            onPressed: () {
              controller.toggle();
            },
          ),
        ),
        body: Page(child: screen),
        resizeToAvoidBottomInset: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SimpleHiddenDrawer(
      isDraggable: true,

      slidePercent: 80,
      typeOpen:
          _settings.isLeftHanded ? TypeOpen.FROM_LEFT : TypeOpen.FROM_RIGHT,
      menu: Menu(),
      curveAnimation: Curves.bounceIn,
      screenSelectedBuilder: screenBuilder,
      //enableScaleAnimin: true,
      verticalScalePercent: 100,
    );
  }

  List<Widget> _buildActions(SimpleHiddenDrawerBloc controller) {
    print(_auth.state);
    return [
      if (_auth.state == AuthState.SIGNED_IN)
        buildUserAvatar(controller)
      else
        FlatButton(
          child: Text(
            'Login',
            style: TextStyle(
              //fontFamily: 'pacifico',
              color: Colors.purple,
            ),
          ),
          onPressed: _navigateToSignIn,
        )
    ];
  }

  Widget buildUserAvatar(SimpleHiddenDrawerBloc controller) {
    return CachedNetworkImage(
      key: Key("myImage"),
      imageBuilder: (context, imageProvider) => GestureDetector(
        onTap: () {
          controller.toggle();
        },
        child: CircleAvatar(
          radius: 27,
          backgroundColor: Theme.of(context).primaryColor,
          child: CircleAvatar(
            radius: 22,
            backgroundImage: imageProvider,
          ),
        ),
      ),
      imageUrl: _auth?.currentUser?.imageUrl ??
          "https://firebasestorage.googleapis.com/v0/b/gadget-security.appspot.com/o/user.png?alt=media&token=960f70f5-f741-46d3-998f-b33be09cbdf6",
      placeholder: (context, url) => Container(
        child: CircularProgressIndicator(),
      ),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }

  void _navigateToSignIn() {
    Navigator.pushNamed(context, '/auth');
  }

  
}

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> with TickerProviderStateMixin {
  AnimationController _animationController;
  bool initConfigState = false;
  Auth _auth;
  SettingsProvider _settings;
  User _currentUser;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _auth = Provider.of<Auth>(context);
    _settings = Provider.of<SettingsProvider>(context);
    _currentUser = _auth.currentUser;
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    confListenerState(context);

    return SafeArea(
      child: Material(
        child: Container(
          width: double.maxFinite,
          height: double.maxFinite,
          child: Stack(
            children: <Widget>[
              Container(
                width: double.maxFinite,
                height: double.maxFinite,
                child: Image.asset(
                  'assets/back3.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Align(
                    alignment: _settings.isLeftHanded
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    child: SizedBox(
                      width: 250,
                      child: CustomScrollView(
                        slivers: <Widget>[
                          if (_currentUser != null)
                            SliverToBoxAdapter(
                              child: Column(
                                children: <Widget>[
                                  CachedNetworkImage(
                                    height: 70,
                                    width: 70,
                                    imageUrl: _currentUser.imageUrl,
                                    imageBuilder: (context, provider) {
                                      return CircleAvatar(
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                        radius: 50,
                                        child: CircleAvatar(
                                          radius: 40,
                                          backgroundImage: provider,
                                        ),
                                      );
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      "${_currentUser.name} ${_currentUser.surname}",
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 20,
                                          decoration: TextDecoration.underline),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text(
                                      "${_currentUser.city},${_currentUser.country}",
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          //fontSize: 30,
                                          decoration: TextDecoration.underline),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          SliverGrid(
                            delegate: SliverChildListDelegate(
                              _buildChildren(context),
                            ),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              //childAspectRatio: .5
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                alignment: _settings.isLeftHanded
                    ? Alignment.topLeft
                    : Alignment.topRight,
                child: IconButton(
                  onPressed: _toggle,
                  icon: Icon(FontAwesomeIcons.bars),
                  color: Theme.of(context).primaryColor,
                  iconSize: 40,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildChildren(BuildContext context) {
    if (_auth.state == AuthState.SIGNED_IN) {
      return [
        buildDrawerButton(context, 0, "Home", Icons.home),
        buildDrawerButton(context, 1, "Settings", Icons.settings),
        buildDrawerButton(context, 2, "Profile", Icons.verified_user),
        buildDrawerButton(context, 3, "Sign out", FontAwesomeIcons.signOutAlt),
        buildDrawerButton(context, 4, "Emergency", FontAwesomeIcons.phoneAlt),
      ];
    } else {
      return [
        buildDrawerButton(context, 0, "Home", Icons.home),
        buildDrawerButton(context, 1, "Settings", Icons.settings),
      ];
    }
  }

  Widget buildDrawerButton(
      BuildContext context, int index, String title, IconData iconData) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(.4),
        //shape: BoxShape.circle,
      ),
      child: InkWell(
        splashColor: Theme.of(context).accentColor,
        onTap: () {
          SimpleHiddenDrawerProvider.of(context).setSelectedMenuPosition(index);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              iconData,
              size: 30,
            ),
            Text(
              title,
              style: TextStyle(color: Theme.of(context).accentColor),
            ),
          ],
        ),
      ),
    );
  }

  void _toggle() {
    SimpleHiddenDrawerProvider.of(context).toggle();
  }

  void confListenerState(BuildContext context) {
    if (!initConfigState) {
      initConfigState = true;
      SimpleHiddenDrawerProvider.of(context)
          .getMenuStateListener()
          .listen((state) {
        if (state == MenuState.open) {
          _animationController.forward();
        }

        if (state == MenuState.closing) {
          _animationController.reverse();
        }
      });
    }
  }
}
