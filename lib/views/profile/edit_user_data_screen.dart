import 'package:flutter/material.dart';

import 'dart:ui';

import 'package:gsec/page.dart';
import 'package:gsec/providers/auth_provider.dart';


class EditUserData extends StatelessWidget {
  final Auth auth;
  final VoidCallback onBlueClick;

  const EditUserData({Key key, this.auth, this.onBlueClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Page(
      child: Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        color: Colors.black.withOpacity(.5),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  
                  Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Edit Profile",
                          style: TextStyle(
                              color: Colors.blue.shade100, fontSize: 30),
                        ),
                      ))
                ],
              ),
              buildTextField("name"),
              buildTextField("email"),
              buildTextField("password"),
              buildTextField("phone"),
              Container(
                margin: EdgeInsets.all(20),
                child: RaisedButton(
                  color: Colors.blue,
                  child: Container(
                    width: double.infinity,
                    child: Center(child: Text("Submit")),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding buildTextField(label) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
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
          hintText: "Enter your" + label,
          labelText: label,
        ),
      ),
    );
  }
}
