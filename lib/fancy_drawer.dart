import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gsec/providers/auth_provider.dart';
import 'package:gsec/providers/settings_provider.dart';
import 'package:gsec/views/authentication/authentication.dart';
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
  // Authentication
  Auth _auth;
  SettingsProvider _settings;
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
        setState(() {
          screen = Dashboard();
        });

        break;
      case 1:
        setState(() {
          screen = Settings();
        });

        break;
      case 2:
        setState(() {
          screen = Profile();
        });
        break;
      case 3:
        _auth.signOut();
        setState(() {
          screen = Dashboard();
        });

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

        controller.toggle();
        SimpleHiddenDrawerProvider.of(context)
            .controllers
            .setPositionSelected(0);
        controller.toggle();
        setState(() {
          screen = Dashboard();
        });

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
        body: screen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SimpleHiddenDrawer(
      typeOpen:
          _settings.isLeftHanded ? TypeOpen.FROM_LEFT : TypeOpen.FROM_RIGHT,
      menu: Menu(),
      screenSelectedBuilder: screenBuilder,
    );
  }

  List<Widget> _buildActions(SimpleHiddenDrawerBloc controller) {
    _auth.checkLoginStatus();
    return [
      if (_auth.state == AuthState.SIGNED_OUT)
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
      else
        buildUserAvatar(controller)
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

  void _signOut() {
    _auth.signOut();
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _auth = Provider.of<Auth>(context);
    _settings = Provider.of<SettingsProvider>(context);
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
          color: Colors.cyan,
          child: Stack(
            children: <Widget>[
              Container(
                  width: double.maxFinite,
                  height: double.maxFinite,
                  child: Image.asset(
                    'assets/back3.jpg',
                    fit: BoxFit.cover,
                  )),
              FadeTransition(
                opacity: _animationController,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Align(
                    alignment: _settings.isLeftHanded
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        buildDrawerButton(context, 0, 'Dashboard'),
                        buildDrawerButton(context, 1, 'Settings'),
                        if (_auth.state == AuthState.SIGNED_IN)
                          buildDrawerButton(context, 2, 'Profile'),
                        if (_auth.state == AuthState.SIGNED_IN)
                          buildDrawerButton(context, 3, 'Logout'),
                      ],
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

  Widget buildDrawerButton(BuildContext context, int index, String title) {
    return BouncingWidget(
      child: SizedBox(
        width: 200.0,
        child: RaisedButton(
          color: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          onPressed: () {
            SimpleHiddenDrawerProvider.of(context)
                .setSelectedMenuPosition(index);
          },
          child: Text(
            title,
            style: TextStyle(color: Theme.of(context).accentColor),
          ),
        ),
      ),
      onPressed: () {},
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
