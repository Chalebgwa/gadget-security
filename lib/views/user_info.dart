import 'package:flutter/material.dart';
import 'package:gsec/models/user.dart';
import 'package:gsec/page.dart';
import 'package:url_launcher/url_launcher.dart';

class UserInfo extends StatelessWidget {
  final User user;
  const UserInfo({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Page(
      
      child: ListView(
        children: <Widget>[
          CircleAvatar(
            radius: 30,
          ),
          Card(
            child: ListTile(
              title: Text(user.name),
            ),
          ),
          Card(
            child: ListTile(
              title: Text(user.surname),
            ),
          ),
          Card(
            child: ListTile(
              title: Text(user.phone),
            ),
          ),
          Card(
            child: ListTile(
              title: Text(user.email),
            ),
          ),
          Card(
            child: ListTile(
              title: Text(user.country),
            ),
          ),
          Card(
            child: ButtonBar(
              alignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.phone),
                  onPressed: () {
                    launch("tel:${user.phone}");
                  },
                ),
                IconButton(
                  icon: Icon(Icons.message),
                  onPressed: () {
                    launch('sms:${user.phone}');
                  },
                ),
                IconButton(
                  icon: Icon(Icons.email),
                  onPressed: () {
                    launch('email:${user.email}');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
