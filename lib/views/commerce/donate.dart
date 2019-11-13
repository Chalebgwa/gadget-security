
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gsec/page.dart';
import 'package:gsec/views/commerce/visa.dart';

class Donate extends StatefulWidget {
  const Donate({Key key}) : super(key: key);

  @override
  _DonateState createState() => _DonateState();
}

class _DonateState extends State<Donate> {
  void navigateToVisa() {
    var route = MaterialPageRoute(builder: (_) => Visa());
    Navigator.push(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Page(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Card(
            child: ListTile(
              onTap: navigateToVisa,
              title: Text("visa"),
              leading: Icon(
                FontAwesomeIcons.ccVisa,
                color: Colors.blue,
              ),
            ),
          ),
          Card(
            child: ListTile(
              title: Text("paypal"),
              leading: Icon(
                FontAwesomeIcons.paypal,
                color: Colors.blue,
              ),
            ),
          ),
          Card(
            child: ListTile(
              title: Text("Crypto"),
              leading: Icon(
                FontAwesomeIcons.bitcoin,
                color: Colors.yellow.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
