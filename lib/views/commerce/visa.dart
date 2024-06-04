import 'dart:ui';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gsec/page.dart';
import 'package:gsec/providers/auth_provider.dart';
import 'package:gsec/util/validator.dart';
import 'package:provider/provider.dart';
import 'package:firebase_admob/firebase_admob.dart';

class Visa extends StatefulWidget {
  final VoidCallback onBlueClick;

  Visa({Key key, this.onBlueClick}) : super(key: key);

  @override
  _VisaState createState() => _VisaState();
}

class _VisaState extends State<Visa> {
  final TextEditingController _cardNumberController =
      new TextEditingController();
  final TextEditingController _ammountCountroler = new TextEditingController();
  final TextEditingController _cvvController = new TextEditingController();
  final TextEditingController _mmyyController = new TextEditingController();
  Auth _auth;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _auth = Provider.of<Auth>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Page(
      child: ListView(children: [
        Container(
          margin: EdgeInsets.all(10),
          color: Colors.black.withOpacity(.4),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: AdmobBanner(
              listener: (AdmobAdEvent e, _) {
                if (e == AdmobAdEvent.loaded) {}
              },
              adSize: AdmobBannerSize.LARGE_BANNER,
              adUnitId: BannerAd.testAdUnitId,
              onBannerCreated: (c) {},
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
          color: Colors.black.withOpacity(.5),
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  buildTextField(
                    "Ammount",
                    _ammountCountroler,
                    false,
                    Validator.validateEmail,
                    FontAwesomeIcons.solidCreditCard,
                  ),
                  buildTextField(
                    "card number",
                    _cardNumberController,
                    false,
                    Validator.validateEmail,
                    FontAwesomeIcons.solidCreditCard,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: buildTextField(
                            "cvv",
                            _cvvController,
                            false,
                            Validator.validateEmail,
                            FontAwesomeIcons.accessibleIcon),
                      ),
                      Expanded(
                        child: buildTextField("mm/yy", _mmyyController, false,
                            Validator.validateEmail, FontAwesomeIcons.calendar),
                      ),
                    ],
                  ),
                  buildLoginButton(null)
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }

  FlatButton buildForgotpassword(Auth auth) {
    return FlatButton(
      child: Text(
        "forgot password",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Enter you email",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _cvvController,
                    decoration: InputDecoration(hintText: "email"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                      color: Colors.blue,
                      child: Text("reset password"),
                      onPressed: donate),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Container buildLoginButton(Auth _auth) {
    return Container(
      margin: EdgeInsets.all(20),
      child: RaisedButton(
        color: Colors.white,
        child: Container(
          width: double.infinity,
          child: Container(
            width: 25,
            height: 25,
            child: Center(
              child: Text("send"),
            ),
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        onPressed: donate,
      ),
    );
  }

  void donate() async {
    String _ammount = _ammountCountroler.text;
    String _cardNumber = _cardNumberController.text;
    String _cvv = _cardNumberController.text;
    String _mmyy = _mmyyController.text;
  }

  Padding buildTextField(label, controller, isPass, validator, icon) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: TextFormField(
        validator: validator,
        controller: controller,
        obscureText: isPass,
        style: TextStyle(
          color: Colors.white,
        ),
        decoration: InputDecoration(
            prefix: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                icon,
                color: Colors.white,
              ),
            ),
            labelStyle: TextStyle(color: Colors.white),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
            hintText: label,
            labelText: label,
            hintStyle: TextStyle(color: Colors.grey)),
      ),
    );
  }
}
