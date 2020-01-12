import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gsec/models/user.dart';
import 'package:gsec/providers/auth_provider.dart';
import 'package:gsec/providers/device_provider.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class DeviceInfo extends StatefulWidget {
  @override
  _DeviceInfoState createState() => _DeviceInfoState();
}

class _DeviceInfoState extends State<DeviceInfo> {
  DeviceProvider _deviceProvider;
  Auth _auth;
  User _owner;
  String _ssn;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _deviceProvider = Provider.of<DeviceProvider>(context);

    _owner = _deviceProvider.owner;
    _ssn = _deviceProvider.details['identifier'];
    _auth = Provider.of<Auth>(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).primaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          QrImage(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Theme.of(context).accentColor,
            size: 300,
            data: _ssn,
          ),
          Divider(),
          if (_owner == null)
            Text('device not registered')
          else
            _buildUserCard(_owner)
        ],
      ),
    );
  }

  Widget _buildUserCard(User owner) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CachedNetworkImage(
            key: Key("myImage"),
            imageBuilder: (context, imageProvider) => CircleAvatar(
              radius: 40,
              backgroundImage: imageProvider,
            ),
            imageUrl: _owner?.imageUrl ??
                "https://firebasestorage.googleapis.com/v0/b/gadget-security.appspot.com/o/user.png?alt=media&token=960f70f5-f741-46d3-998f-b33be09cbdf6",
            placeholder: (context, url) => Container(
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          Text(
            '${_owner.name } ${_owner.surname}',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            '${_owner.phone}',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w100),
          ),
          Divider(),
          ButtonBar(
            alignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                icon: Icon(FontAwesomeIcons.phone),
                onPressed: () {
                  launch("tel:${_owner.phone}");
                },
              ),
              IconButton(
                icon: Icon(FontAwesomeIcons.envelope),
                onPressed: () {
                  launch("tel:${_owner.phone}");
                },
              ),

            ],
          ),
        ],
      ),
    );
  }
}
