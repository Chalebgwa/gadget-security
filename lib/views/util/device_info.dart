import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gsec/providers/auth_provider.dart';
import 'package:gsec/providers/device_provider.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DeviceInfo extends StatefulWidget {
  @override
  _DeviceInfoState createState() => _DeviceInfoState();
}

class _DeviceInfoState extends State<DeviceInfo> {
  DeviceProvider _deviceProvider;
  Auth _auth;

  String ssn;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _deviceProvider = Provider.of<DeviceProvider>(context);
    _deviceProvider.fetchDeviceID().then((value) {
      setState(() {
        ssn = value;
      });
    });
    _auth = Provider.of<Auth>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(40),
      color: Colors.transparent,
      child: Material(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Column(
          children: <Widget>[
            ButtonBar(
              alignment: MainAxisAlignment.start,
              children: <Widget>[
                CircleAvatar(
                  radius: 30,
                ),
                Text(_auth?.currentUser?.name ?? "User name")
              ],
            ),
            Text(
              _auth?.currentUser?.gorvenmentId ?? "GORVERNMENT ID",
              style: TextStyle(fontSize: 30),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: QrImage(
                data: ssn,
              ),
            ),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  child: Icon(FontAwesomeIcons.phone),
                  onPressed: () {},
                ),
                FlatButton(
                  child: Icon(FontAwesomeIcons.envelope),
                  onPressed: () {},
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
