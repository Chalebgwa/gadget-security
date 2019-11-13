import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gsec/providers/auth_provider.dart';
import 'package:gsec/util/validator.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  final VoidCallback onBlueClick;

  SignIn({Key key, this.onBlueClick}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
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
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
      color: Colors.black.withOpacity(.5),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Login",
                          style: TextStyle(
                              color: Colors.blue.shade100, fontSize: 30),
                        ),
                      )),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FloatingActionButton(
                        child: Icon(
                          FontAwesomeIcons.solidArrowAltCircleRight,
                          color: Colors.blue,
                        ),
                        onPressed: widget.onBlueClick,
                        backgroundColor: Colors.black,
                      ),
                    ),
                  )
                ],
              ),
              buildTextField(
                  "email", _emailController, false, Validator.validateEmail),
              buildTextField("password", _passwordController, true,
                  Validator.validatePassword),
              buildLoginButton(_auth),
              buildForgotpassword(_auth)
            ],
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
                      onPressed: login,
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
          color: Colors.white,
          child: Container(
            width: double.infinity,
            child: Container(
                width: 25, height: 25, child: Center(child: Text("Sign In"))),
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
          color: Colors.white,
        ),
        decoration: InputDecoration(
            labelStyle: TextStyle(color: Colors.white),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
            hintText: "Enter your " + label,
            labelText: label,
            hintStyle: TextStyle(color: Colors.grey)),
      ),
    );
  }
}
