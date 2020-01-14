import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gsec/providers/auth_provider.dart';
import 'package:gsec/util/validator.dart';
import 'package:gsec/views/dashboard.dart';
import 'package:hidden_drawer_menu/hidden_drawer/hidden_drawer_menu.dart';
import 'package:hidden_drawer_menu/simple_hidden_drawer/bloc/simple_hidden_drawer_bloc.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  final VoidCallback onBlueClick;
  final SimpleHiddenDrawerBloc controller;

  SignIn({Key key, this.onBlueClick, this.controller}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _resetController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  Auth _auth;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  SimpleHiddenDrawerBloc controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _auth = Provider.of<Auth>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 80),
                  child: Text(
                    "Login",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 30,
                      fontFamily: 'pacifico',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FloatingActionButton(
                    heroTag: 'blue',
                    child: Icon(
                      FontAwesomeIcons.solidArrowAltCircleRight,
                      color: Colors.purple,
                    ),
                    onPressed: widget.onBlueClick,
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                )
              ],
            ),

            Container(
              margin: EdgeInsets.only(left: 20, right: 20, bottom: 20,top: 20),
              color: Theme.of(context).primaryColor.withOpacity(.4),
              child: Column(
                children: <Widget>[
                  buildTextField("email", _emailController, false,
                      Validator.validateEmail),
                  buildTextField("password", _passwordController, true,
                      Validator.validatePassword),
                  buildLoginButton(_auth),
                  
                ],
              ),
            ),
            buildForgotpassword(_auth)
          ],
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
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                      ),
                      controller: _resetController,
                      decoration: InputDecoration(
                          hintText: "email", border: UnderlineInputBorder()),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      elevation: 50,
                      color: Theme.of(context).primaryColor,
                      child: Text("reset password"),
                      onPressed: reset,
                    ),
                  )
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
        color: Theme.of(context).primaryColor,
        child: Container(
          width: double.infinity,
          child: Container(
              width: 25, height: 25, child: Center(child: Text("Sign In"))),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        onPressed: login,
      ),
    );
  }

  void reset() async {
    String email = _resetController.text;
    String message = await _auth.resetPassword(email);
    Navigator.pop(context);
    Fluttertoast.showToast(msg: message);
  }

  void login() async {
    String email = _emailController.text;
    String password = _passwordController.text;
    Navigator.pop(context);

    // sign in with email and password
    bool result = await _auth.signInWithEmail(email, password);

    if (result) {
      Fluttertoast.showToast(msg: "Login Successful");
    } else {
      Fluttertoast.showToast(msg: "Login Failed");
    }
  }

  Padding buildTextField(label, controller, isPass, validator) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        validator: validator,
        controller: controller,
        obscureText: isPass,
        style: TextStyle(
          color: Theme.of(context).accentColor,
        ),
        decoration: InputDecoration(
            labelStyle:
                TextStyle(color: Theme.of(context).accentColor.withOpacity(.5)),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).accentColor,
              ),
            ),
            hintText: "Enter your " + label,
            labelText: label,
            hintStyle: TextStyle(
                color: Theme.of(context).accentColor.withOpacity(.5))),
      ),
    );
  }
}
