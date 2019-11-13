import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gsec/page.dart';
import 'package:gsec/providers/auth_provider.dart';
import 'package:gsec/util/validator.dart';
import 'package:provider/provider.dart';

class Visa extends StatefulWidget {
  final VoidCallback onBlueClick;

  Visa({Key key, this.onBlueClick}) : super(key: key);

  @override
  _VisaState createState() => _VisaState();
}

class _VisaState extends State<Visa> {
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _resetController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
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
      child: Container(
        margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
        color: Colors.black.withOpacity(.5),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                buildTextField("card number", _emailController, false,
                    Validator.validateEmail, FontAwesomeIcons.solidCreditCard),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: buildTextField(
                          "cvv",
                          _emailController,
                          false,
                          Validator.validateEmail,
                          FontAwesomeIcons.accessibleIcon),
                    ),
                    Expanded(
                      child: buildTextField("mm/yy", _emailController, false,
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
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _resetController,
                      decoration: InputDecoration(hintText: "email"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                        color: Colors.blue,
                        child: Text("reset password"),
                        onPressed: login),
                  ),
                ],
              );
            });
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
                width: 25, height: 25, child: Center(child: Text("send"))),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          onPressed: login),
    );
  }

  void login() async {
    String email = _emailController.text;
    String password = _passwordController.text;
    _auth.signInWithEmail(email, password).then((result) {
      if (_auth.state == AuthState.SIGNED_IN) {
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    }).then((value) {
      Navigator.pop(context);
    });
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
