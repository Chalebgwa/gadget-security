import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gsec/models/device.dart';
import 'package:gsec/models/user.dart';
import 'package:gsec/providers/auth_provider.dart';
import 'package:gsec/providers/device_provider.dart';
import 'package:gsec/widgets/user_selector.dart';
import 'package:provider/provider.dart';

enum Action { NO, OK, ALERT }

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
  TextEditingController _pinController = TextEditingController();

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
    if (peer != null) {
      var action = await pinConfirm(peer);
      print(action);
      switch (action) {
        case Action.OK:
          _auth.transfer(peer, widget.device);
          break;
        case Action.NO:
          break;
        case Action.ALERT:
          _auth.alertSecurity(peer);
          break;
        default:
      }
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
            backgroundColor: Theme.of(context).primaryColor,
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

  Future<Action> pinConfirm(User peer) async {
    String content = '';

    return showDialog<Action>(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text("Type in Security Pin"),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _pinController,
                decoration: InputDecoration(
                  hintText: "Type In Security Pin",
                ),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                color: Theme.of(context).accentColor,
                child: Text("Yes"),
                onPressed: () async {
                  if (_pinController.text.length > 0) {
                    _auth.confirmWithPin(_pinController.text);
                    Navigator.pop(context, Action.ALERT);
                  }
                },
              ),
              FlatButton(
                color: Theme.of(context).accentColor,
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
                  buildListDetail("NAME", widget.device.name ?? "-"),
                  buildListDetail("IMEI", widget.device.imei ?? "-"),
                  buildListDetail("TYPE", widget.device.type ?? "-"),
                ],
              ),
            ),
          );
        });
  }

  Container buildListHeader() {
    return Container(
      color: Theme.of(context).accentColor,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Icon(
              FontAwesomeIcons.checkCircle,
              color: widget.device.confirmed
                  ? Colors.green
                  : Theme.of(context).primaryColor,
            ),
          ),
          Expanded(
            child: IconButton(
              color: Theme.of(context).primaryColor,
              icon: Icon(FontAwesomeIcons.exchangeAlt),
              onPressed: getUser,
            ),
          ),
          Expanded(
            
            child: IconButton(
              color: Theme.of(context).primaryColor,
              icon: Icon(Icons.delete),
              onPressed: deleteDevice,
            ),
          ),
          Expanded(
            child: IconButton(
              color: Theme.of(context).primaryColor,
              icon: Icon(Icons.edit),
              onPressed: deleteDevice,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildListDetail(String label, String detail) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Theme.of(context).primaryColor,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            Text(
              detail,
              style: TextStyle(fontSize: 15),
            ),
            Divider()
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                  offset: Offset(5,5),
                  color: Theme.of(context).accentColor.withOpacity(0.1),
                  blurRadius: 1),
              BoxShadow(
                  offset: Offset(-5, -5),
                  color: Theme.of(context).accentColor.withOpacity(.1),
                  blurRadius: 1),
            ]),
        child: InkWell(
          onTap: () {
            _showDeviceInfo(context);
          },
          child: Center(
            child: SizedBox(
              width: 90,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    widget.device.name,
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Laptop",
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
