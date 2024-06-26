import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gsec/page.dart' as p;
import 'package:gsec/providers/auth_provider.dart';
import 'package:gsec/views/authentication/registration.dart';
import 'package:gsec/views/authentication/sign_in.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:provider/provider.dart';

class Athentication extends StatefulWidget {
  final HiddenDrawerMenu bloc;

  Athentication({Key? key, required this.bloc}) : super(key: key);

  @override
  _AthenticationState createState() => _AthenticationState();
}

class _AthenticationState extends State<Athentication> {
  final PageController pageController = new PageController();

  String actionText = "Register";

  void toggleView() {
    if (actionText == "Register") {
      registerPage();
      setState(() {
        actionText = "Login";
      });
    } else {
      loginPage();
      setState(() {
        actionText = "Register";
      });
    }
  }

  void registerPage() {
    pageController.nextPage(
      curve: Curves.fastOutSlowIn,
      duration: Duration(seconds: 1),
    );
  }

  void loginPage() {
    //pageController.jumpToPage(1);
    pageController.previousPage(
      curve: Curves.fastOutSlowIn,
      duration: Duration(seconds: 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return p.Page(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          title: Text(
            'Gadget Security',
            style: TextStyle(fontFamily: 'pacifico', fontSize: 15),
          ),
          centerTitle: true,
          actions: <Widget>[
            TextButton(
              child: Text(
                actionText,
                style: TextStyle(fontSize: 10, color: Colors.purple),
              ),
              onPressed: toggleView,
            )
          ],
        ),
        body: PageView(
          pageSnapping: true,
          controller: pageController,
          scrollDirection: Axis.vertical,
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            SignIn(
              onBlueClick: registerPage,
              controller: widget.bloc,
            ),
            Registration(
              auth: context.read<Auth>(),
              onBlueClick: loginPage,
              controller: widget.bloc,
            )
          ],
        ),
      ),
    );
  }
}
