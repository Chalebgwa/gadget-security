import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gsec/models/device.dart';
import 'package:gsec/models/user.dart';
import 'package:gsec/providers/auth_provider.dart';
import 'package:gsec/providers/device_provider.dart';
import 'package:gsec/widgets/user_selector.dart';
import 'package:provider/provider.dart';

enum Action { NO, OK }

class DeviceCard extends StatefulWidget {
  final Device device;

  const DeviceCard({
    Key key,
    this.device,
  }) : super(key: key);

  @override
  _DeviceCardState createState() => _DeviceCardState();
}

class _DeviceCardState extends State<DeviceCard> {
  Auth _auth;
  DeviceProvider _deviceProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _auth = Provider.of<Auth>(context);
    _deviceProvider = Provider.of<DeviceProvider>(context);
  }

  void getUser() async {
    Navigator.pop(context);
    var route = MaterialPageRoute<User>(builder: (context) => UserSelector());
    User peer = await Navigator.push<User>(context, route);
    var action = await showConfirmDialog("trade", peer: peer);

    switch (action) {
      case Action.OK:
        _auth.transfer(peer, widget.device);
        break;
      case Action.NO:
        break;
      default:
    }
  }

  Future<Action> showConfirmDialog(String action, {User peer}) async {
    String content = '';
    if (action != 'trade') {
      content = "Are you sure want to delete ${widget.device.name}";
    } else {
      content =
          "Are you sure want to trade ${widget.device.name} with ${peer.name}";
    }

    return showDialog<Action>(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text("Warning"),
            content: Text(content),
            actions: <Widget>[
              FlatButton(
                child: Text("Yes"),
                onPressed: () {
                  Navigator.pop(context, Action.OK);
                },
              ),
              FlatButton(
                child: Text("No"),
                onPressed: () {
                  Navigator.pop(context, Action.NO);
                },
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
          );
        });
  }

  void deleteDevice() async {
    Navigator.pop(context);
    var action = await showConfirmDialog("delete");
    switch (action) {
      case Action.OK:
        _deviceProvider.removeDevice(widget.device);
        break;
      case Action.NO:
        break;
      default:
    }
    //
  }

  void _showDeviceInfo(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: Container(
              color: Colors.grey.shade200,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  buildListHeader(),
                  buildListDetail("SSN", widget.device.identifier),
                ],
              ),
            ),
          );
        });
  }

  Container buildListHeader() {
    return Container(
      color: Colors.blue,
      child: IconTheme(
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  widget.device.name.toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: IconButton(
                icon: Icon(FontAwesomeIcons.exchangeAlt),
                onPressed: getUser,
              ),
            ),
            Expanded(
              child: IconButton(
                icon: Icon(Icons.delete),
                onPressed: deleteDevice,
              ),
            ),
            Expanded(
              child: IconButton(
                icon: Icon(Icons.edit),
                onPressed: deleteDevice,
              ),
            ),
          ],
        ),
        data: IconThemeData(color: Colors.white),
      ),
    );
  }

  Padding buildListDetail(String label, String detail) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Text(
            detail,
            style: TextStyle(fontSize: 15),
          ),
          Divider()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          colors: [
            Colors.white,
            Colors.red,
          ],
          begin: Alignment.topCenter,
          stops: [
            2.0,
            2.0,
          ],
        ),
      ),
      child: InkWell(
        onTap: () {
          _showDeviceInfo(context);
        },
        child: Center(
          child: SizedBox(
            width: 90,
            child: Text(
              widget.device.name,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}