
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gsec/pages/forms/computer_form.dart';
import 'package:gsec/pages/forms/mobile_form.dart';
import 'package:gsec/pages/forms/monitor_form.dart';
import 'package:gsec/pages/forms/other_form.dart';
import 'package:gsec/pages/page.dart';
import 'package:gsec/widgets/device_card.dart';

class Forms extends StatefulWidget {
  const Forms({Key key}) : super(key: key);

  @override
  _FormsState createState() => _FormsState();
}

class _FormsState extends State<Forms> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/back.jpg"), fit: BoxFit.fill),
              ),
            ),
            Container(
              color: Colors.black.withOpacity(.8),
              alignment: Alignment.center,
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: DeviceCard(),
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Pick your Device type",
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                  SliverGrid(
                    delegate: SliverChildListDelegate(
                      [
                        formCard("Mobile", Icons.phone, MobileForm()),
                        formCard("Computer", Icons.computer, ComputerForm()),
                        formCard("Tv/Monitor", FontAwesomeIcons.tv, MonitorForm()),
                        formCard("Other", Icons.device_unknown, OtherForm()),
                      ],
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget formCard(label, icon, form) {
    return InkWell(
      onTap: () {
        var route = animateRoute(context: context, page: form);
        Navigator.push(context, route);
      },
      child: Container(
        margin: EdgeInsets.all(7),
        color: Colors.black.withOpacity(.3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
