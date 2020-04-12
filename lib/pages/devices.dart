import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gsec/pages/forms/forms.dart';
import 'package:gsec/pages/page.dart';
import 'package:gsec/widgets/device_card.dart';

class Devices extends StatelessWidget {
  const Devices({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          var route = animateRoute(context: context, page: Forms());
          Navigator.push(context, route);
        },
        child: Icon(Icons.add),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/back.jpg"),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(.7),
          ),
          AnimatedList(
            initialItemCount: 100,
            itemBuilder: (context, index, animation) {
              if (index == 0) {
                return PrimaryDevice();
              }
              return DeviceCard();
            },
          ),
        ],
      ),
    );
  }
}
