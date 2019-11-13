import 'package:flutter/material.dart';
import 'package:gsec/page.dart';
import 'package:gsec/views/authentication/registration.dart';
import 'package:gsec/views/authentication/sign_in.dart';

class Athentication extends StatelessWidget {
  final PageController pageController = new PageController();

  void registerPage() {
    pageController.nextPage(
      curve: Curves.bounceInOut,
      duration: Duration(seconds: 1),
    );
  }

  void loginPage() {
    //pageController.jumpToPage(1);
    pageController.previousPage(
      curve: Curves.bounceInOut,
      duration: Duration(seconds: 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Page(
      child: PageView(
        pageSnapping: true,
        controller: pageController,
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          SignIn(
            onBlueClick: registerPage,
          ),
          Registration(
            onBlueClick: loginPage,
          )
        ],
      ),
    );
  }
}
