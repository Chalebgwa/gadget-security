import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gsec/widgets/nm_box.dart';

class FancyButton extends StatelessWidget {
  const FancyButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.grey.shade200,
          boxShadow: [
            BoxShadow(
              color: mCD,
              offset: Offset(-4, -4),
              blurRadius: 1,
            ),
            BoxShadow(
              color: Colors.white,
              offset: Offset(4, 4),
              blurRadius: 10,
            ),
          ]),
      child: Icon(FontAwesomeIcons.user),
    );
  }
}
