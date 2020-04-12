import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gsec/pages/authentication/sign_in.dart';
import 'package:gsec/pages/device_info.dart';
import 'package:gsec/pages/page.dart';
import 'package:gsec/pages/settings.dart';
import 'package:gsec/widgets/dashcard.dart';
import 'package:gsec/widgets/fancy_drawer.dart';
import 'package:gsec/widgets/nm_box.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class Dashboard extends StatelessWidget {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  Dashboard({Key key}) : super(key: key);
  void turnPage(int page) {}

  void scan(BuildContext context) async {
    String value = await scanner.scan();
    var snackbar = SnackBar(content: Text(value ?? "Error"));
    Scaffold.of(context).showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    var _topColor = Colors.grey.shade200;

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        endDrawer: FancyDrawer(),
        backgroundColor: _topColor,
        body: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/back.jpg"), fit: BoxFit.fill)),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(.7),
              ),
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          //FlatButton(onPressed: (){}, child: Text("Premium",style: TextStyle(color: Colors.yellow),),),
                          Expanded(child: Container()),
                          TopButton(
                            icon: FontAwesomeIcons.lock,
                            label: "Sign In",
                            onTap: () {
                              var route = animateRoute(
                                context: context,
                                page: SignIn(),
                              );
                              Navigator.push(context, route);
                            },
                          ),
                          TopButton(
                            icon: FontAwesomeIcons.bars,
                            label: "Menu",
                            onTap: () {
                              _scaffoldKey.currentState.openEndDrawer();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10, left: 10),
                      child: Container(
                        height: 230,
                        child: RichText(
                          textAlign: TextAlign.start,
                          text: TextSpan(
                            text: "Welcome to\n",
                            style: TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.w100,
                            ),
                            children: [
                              TextSpan(
                                text: "Gadget Security\n",
                                style: TextStyle(
                                  fontSize: 50,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              TextSpan(
                                text: "'Reinvented Protection'",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w100,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Search Device Owner",
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.search,
                            decoration: InputDecoration(
                              suffixIcon: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: IconButton(
                                    icon: Icon(FontAwesomeIcons.search),
                                    onPressed: () {}),
                              ),
                              focusColor: Colors.purple,
                              hoverColor: Colors.red,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(39),
                                  gapPadding: 30),
                              fillColor: Colors.white.withOpacity(.4),
                              filled: true,
                              hintText: "Search",
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 100,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: FlatButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      onPressed: () {
                                        var route = animateRoute(
                                          context: context,
                                          page: DeviceInfo(),
                                        );

                                        Navigator.push(context, route);
                                      },
                                      child: Container(
                                        height: 50,
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Device Info",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      color: Colors.purple,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: FlatButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      onPressed: () {
                                        scan(context);
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Text("Scan QR code"),
                                        height: 50,
                                      ),
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Color _topColor, BuildContext context) {
    return Container(
      decoration: nMbox.copyWith(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        color: Colors.purple[200],
      ),
      //color: Colors.purple,
      child: Column(
        children: <Widget>[
          Container(
            //color: _topColor,
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 16, left: 8, right: 8, bottom: 32),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      "Gadget Security",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.lock_open,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      var route = animateRoute(
                        context: context,
                        page: SignIn(),
                      );
                      Navigator.push(context, route);
                    },
                  ),
                  IconButton(
                    icon: Hero(
                      tag: "settingsIcon",
                      child: Icon(
                        Icons.tune,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    onPressed: () {
                      var route = animateRoute(
                        page: Settings(),
                        context: context,
                      );
                      Navigator.push(
                        context,
                        route,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  TopButton(
                      icon: Icons.camera,
                      label: "Scan",
                      onTap: () {
                        scan(context);
                      }),
                  TopButton(
                    icon: Icons.perm_device_information,
                    label: "Device Info",
                    onTap: () {
                      var route = animateRoute(
                        page: DeviceInfo(),
                        context: context,
                      );
                      Navigator.push(
                        context,
                        route,
                      );
                    },
                  ),
                  TopButton(
                    icon: FontAwesomeIcons.exchangeAlt,
                    label: "Sell",
                    lock: true,
                    onTap: () {
                      turnPage(2);
                    },
                  ),
                  TopButton(
                    icon: Icons.add,
                    label: "New Device",
                    lock: true,
                    onTap: () {
                      turnPage(3);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
