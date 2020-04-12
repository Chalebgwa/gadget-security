import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gsec/pages/about_us.dart';
import 'package:gsec/pages/devices.dart';
import 'package:gsec/pages/page.dart';
import 'package:gsec/pages/payments_view.dart';
import 'package:gsec/pages/settings.dart';
import 'package:gsec/provider/payments.dart';
import 'package:provider/provider.dart';

class FancyDrawer extends StatefulWidget {
  const FancyDrawer({Key key}) : super(key: key);

  @override
  _FancyDrawerState createState() => _FancyDrawerState();
}

class _FancyDrawerState extends State<FancyDrawer>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animation;

  Payments _paymentsProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _paymentsProvider = Provider.of<Payments>(context);
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 0, end: 30).animate(_animationController);
  }

  Future<void> share() async {
    await FlutterShare.share(
      title: 'Share Gadget Security',
      text: 'Check out this amazing applictcation',
      linkUrl: 'https://flutter.dev/',
      chooserTitle: 'Gadget Security',
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        _animationController.forward();
        Navigator.pop(context);
      },
      child: Container(
        height: double.infinity,
        alignment: Alignment.center,

        ///color: Colors.white.withOpacity(.5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DrawerItem(
              animation: _animation,
              label: "My Devices",
              icon: FontAwesomeIcons.mobile,
              time: 20.0,
              onTap: () {
                _navigateTo(context, Devices());
              },
            ),
            DrawerItem(
              animation: _animation,
              label: "Settings",
              icon: FontAwesomeIcons.cog,
              time: 10.0,
              onTap: () {
                _navigateTo(context, Settings());
              },
            ),
            DrawerItem(
              animation: _animation,
              label: "Premium",
              icon: FontAwesomeIcons.moneyBill,
              time: 30.0,
              onTap: _paymentsProvider?.pay,
            ),
            DrawerItem(
              animation: _animation,
              label: "Share",
              icon: FontAwesomeIcons.share,
              time: 40.0,
              onTap: share,
            ),
            DrawerItem(
              animation: _animation,
              label: "About Us",
              icon: FontAwesomeIcons.info,
              time: 50.0,
              onTap: () {
                _navigateTo(context, AboutUs());
              },
            ),
          ],
        ),
      ),
    );
  }

  void _navigateTo(BuildContext context, page) {
    Navigator.pop(context);
    var route = animateRoute(context: context, page: page);
    Navigator.push(context, route);
  }
}

class DrawerItem extends StatefulWidget {
  DrawerItem(
      {Key key, this.label, this.icon, this.animation, this.onTap, this.time})
      : super(key: key);
  final String label;
  final IconData icon;
  final Animation<double> animation;
  final VoidCallback onTap;
  final double time;

  @override
  _DrawerItemState createState() => _DrawerItemState();
}

class _DrawerItemState extends State<DrawerItem>
    with SingleTickerProviderStateMixin {
  Animation<Offset> _offset;
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    print(widget.time);
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600 + (widget.time.floor() * 10)),
      reverseDuration: Duration(seconds: 3),
    );

    _offset = Tween<Offset>(
      end: Offset((0 + widget.time / 100), 0),
      begin: Offset(10, 12.0),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.fastOutSlowIn,
      ),
    );

    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            bottomLeft: Radius.circular(30),
          ),
        ),
        margin: EdgeInsets.all(2.0),
        color: Colors.black.withOpacity(.8),
        child: ListTile(
            leading: Hero(
              tag: "${widget.label} hero",
              child: Icon(
                widget.icon,
                color: Colors.purple,
              ),
            ),
            title: Container(
              child: Text(
                widget.label,
                style: TextStyle(color: Colors.white),
              ),
            ),
            onTap: widget.onTap),
      ),
      position: _offset,
    );
  }

  @override
  void dispose() {
    //_animationController.forward();
    _animationController.dispose();
    super.dispose();
  }
}
