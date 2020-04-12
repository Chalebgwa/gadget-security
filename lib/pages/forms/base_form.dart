import 'package:flutter/material.dart';

class BaseForm {
  final List<TextEditingController> controllers;
  final List<FocusNode> nodes;
  final List<String> labels;

  BaseForm({this.labels, this.controllers, this.nodes});

  Widget generateForm() {
    return Form(
      child: Column(
        children: <Widget>[
          
        ],
      ),
    );
  }
}
