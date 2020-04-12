import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gsec/models/device.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DeviceInfo extends StatelessWidget {
  const DeviceInfo({Key key, this.device}) : super(key: key);

  final Device device;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
            height: double.infinity,
            width: double.infinity,
            color: Colors.black.withOpacity(.6),
          ),
          Flex(
            direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.purple[200],
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.purple[200],
                        radius: 40,
                        child: Icon(
                          FontAwesomeIcons.user,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              _ListItem(
                label: "Serial",
                value: "754244428332",
                icon: Icons.perm_device_information,
              ),
              _ListItem(
                label: "Owner",
                value: "Pako Chalebgwa",
                icon: FontAwesomeIcons.user,
              ),
              _ListItem(
                label: "Mobile",
                value: "+267 77147912",
                icon: FontAwesomeIcons.phone,
              ),
              _ListItem(
                label: "City/Town",
                value: "Francistown",
                icon: FontAwesomeIcons.mapPin,
              ),
              ButtonBar(
                alignment: MainAxisAlignment.spaceEvenly,
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
        ],
      ),
    );
  }
}

class _ListItem extends StatelessWidget {
  const _ListItem({Key key, this.label, this.value, this.icon})
      : super(key: key);

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.white,
        ),
        title: Text(
          label, 
          style: TextStyle(
            fontWeight: FontWeight.w100,
            fontSize: 20,
            color: Colors.white,

          ),
        ),
        subtitle: Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w300,
            color: Colors.purple[200],
          ),
        ),
      ),
    );
  }
}
