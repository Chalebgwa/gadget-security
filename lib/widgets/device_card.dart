import 'package:flutter/material.dart';
import 'package:gsec/models/device.dart';
import 'package:gsec/pages/device_view.dart';
import 'package:gsec/pages/page.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DeviceCard extends StatefulWidget {
  const DeviceCard({Key key, this.device}) : super(key: key);

  final Device device;

  @override
  _DeviceCardState createState() => _DeviceCardState();
}

class _DeviceCardState extends State<DeviceCard> {
  @override
  Widget build(BuildContext context) {
    var labelStyle = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 10,
      //decoration: TextDecoration.underline
    );
    var valuetextStyle = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w100,
      fontSize: 15,
    );
    return InkWell(
      onTap: () {
        var route = animateRoute(
          context: context,
          page: DeviceView(),
        );
        Navigator.push(context, route);
        print("hello");
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                QrImage(
                  data: "1232568565",
                  foregroundColor: Colors.white,
                  gapless: true,
                  size: 150,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(
                        "Device Name",
                        style: labelStyle,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(
                        "SAMSUNG-J2FU",
                        style: valuetextStyle,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(
                        "Device Serial",
                        style: labelStyle,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text("1002-5966-263-5", style: valuetextStyle),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(
                        "Device Type",
                        style: labelStyle,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Text(
                        "mobile",
                        style: valuetextStyle,
                      ),
                    ),
                    Divider()
                  ],
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.white,
            endIndent: 10,
            indent: 10,
          ),
        ],
      ),
    );
  }
}

class PrimaryDevice extends StatelessWidget {
  const PrimaryDevice({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var labelStyle = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 10,
      //decoration: TextDecoration.underline
    );
    var valuetextStyle = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w100,
      fontSize: 15,
    );

    return InkWell(
      onTap: () {},
      child: Container(
        height: 300,
        width: double.infinity,
        color: Colors.black.withOpacity(.3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Primary Device",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                QrImage(
                  data: "1233",
                  size: 100,
                  backgroundColor: Colors.white,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Device",
                      style: labelStyle,
                    ),
                    Text(
                      "Device",
                      style: valuetextStyle,
                    ),
                    Text(
                      "Device",
                      style: labelStyle,
                    ),
                    Text(
                      "Device",
                      style: valuetextStyle,
                    ),
                    Text(
                      "Device",
                      style: labelStyle,
                    ),
                    Text(
                      "Device",
                      style: valuetextStyle,
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
