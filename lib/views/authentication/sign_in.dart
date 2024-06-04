import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gsec/providers/auth_provider.dart';
import 'package:gsec/util/validator.dart';
import 'package:gsec/views/dashboard.dart';

import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  final VoidCallback onBlueClick;
  final  controller;

  SignIn({Key? key, required this.onBlueClick, this.controller}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _resetController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  late Auth _auth;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  dynamic controller;

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
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.transparent,
      body: Form(
        key: _formKey,
        child: Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Flexible(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor:
                      Theme.of(context).primaryColor.withOpacity(.4),
                  child: Image.asset(
                    "assets/splash.png",
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 2,
              child: Container(
                margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
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
            ),
            buildForgotpassword(_auth)
          ],
        ),
      ),
    );
  }

  TextButton buildForgotpassword(Auth auth) {
    return TextButton(
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
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                      controller: _resetController,
                      decoration: InputDecoration(
                        hintText: "email",
                        border: UnderlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                       
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
      child: ElevatedButton(
       // : Theme.of(context).primaryColor,
        child: Container(
          width: double.infinity,
          child: Container(
              width: 25, height: 25, child: Center(child: Text("Sign In"))),
        ),
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(30),
        // ),
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
            prefixIcon: Icon(
              label == "email" ? Icons.email : Icons.lock,
              color: Colors.purple,
            ),
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
