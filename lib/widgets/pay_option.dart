import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PayOption extends StatelessWidget {
  const PayOption(
      {Key key, this.label, this.onPressed, this.leading, this.color})
      : super(key: key);
  final String label;
  final VoidCallback onPressed;
  final Widget leading;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text("visa"),
        leading: Icon(
          FontAwesomeIcons.ccVisa,
          color: Colors.blue,
        ),
      ),
    );
  }
}
