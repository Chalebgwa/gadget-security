import 'package:cached_network_image/cached_network_image.dart';
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
          buildUserAvatar(user),
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


  Stack buildUserAvatar(User user) {
    return Stack(
      children: <Widget>[
        CachedNetworkImage(
          key: Key("myImage"),
          imageBuilder: (context, imageProvider) => CircleAvatar(
            radius: 35,
            backgroundColor: Theme.of(context).primaryColor,
            child: CircleAvatar(
              radius: 30,
              backgroundImage: imageProvider,
            ),
          ),
          imageUrl: user.imageUrl ??
              "https://firebasestorage.googleapis.com/v0/b/gadget-security.appspot.com/o/user.png?alt=media&token=960f70f5-f741-46d3-998f-b33be09cbdf6",
          placeholder: (context, url) => Container(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ],
    );
  }
}
